extends Node2D

export var max_scale = 2.4
export var max_rotation_degrees = 3.0
var oscillations = 2
var animation_duration = 0.6
var animation_speed = 1.5
var is_animating = false
var animation_timer = 0.0
var original_scale = Vector2(2,2)
var original_rotation = 0.0
var nombre = ""

var yo = {}

enum AnimState { IDLE, ENTER, HOVER, EXIT }
var anim_state = AnimState.IDLE
var anim_time = 0.0

var scale_puede_cambiar = false

var mouse_over = false  # indicador si el mouse esta dentro


func _ready():
	$AnimationPlayer.play("aparecer")
	$Descripcion.visible = false
	get_node("Sprite-top").material.set_shader_param('outline_size', 0)
	original_rotation = get_node("Sprite").rotation
	
	get_node("Sprite-top").material = get_node("Sprite-top").material.duplicate()
	
	get_node("Sprite").material = get_node("Sprite").material.duplicate()
	get_node("Parte_de_costado").material = get_node("Parte_de_costado").material.duplicate()
	
	if Global.METODO_DE_CAIDA == "3d":
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 1)
	else:
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 0)
	
	# Conectar ambos detectores al mismo metodo
	var _a = $detector2.connect("mouse_entered", self, "_on_mouse_entered", [ "detector2" ])
	_a = $detector2.connect("mouse_exited", self, "_on_mouse_exited", [ "detector2" ])
	_a = $detector3.connect("mouse_entered", self, "_on_mouse_entered", [ "detector3" ])
	_a = $detector3.connect("mouse_exited", self, "_on_mouse_exited", [ "detector3" ])
	
	var base_color = get_mixed_color(get_node("Sprite"))
	get_node("Sprite-top").material.set_shader_param("original_color", base_color)
	
	# agregar al grupo para control global de focus
	add_to_group("dominos")
	
	# opcional: aseguramos estado consistente al inicio
	update_focus()


var elemento_en_juego = false


func _process(delta):
	if get_parent().get_parent().get_parent().get_parent().baraja_activa == "baraja_especial":
		elemento_en_juego = mouse_over_area(get_tree().root.get_node("Game/Viewport/GameArea/Area2D"), 1)
		
		if $Sprite.visible:
			mouse_over = mouse_over_area($detector2, 1)
		else:
			mouse_over = mouse_over_area($detector3, 0.5)
		
		if valor_dragin != get_parent().dragging:
			update_focus()
			valor_dragin = get_parent().dragging
		
		actualizar_sombra()
		
		if anim_state != AnimState.IDLE:
			anim_time += delta * animation_speed
		
		var sprite = get_node("Sprite")
		
		if scale_puede_cambiar and get_parent().arrastrado != self:
			match anim_state:
				AnimState.ENTER:
					var t = clamp(anim_time / (animation_duration * 0.5), 0.0, 1.0)
					var k = sin(t * PI * 0.5)
					sprite.scale = original_scale.linear_interpolate(Vector2(max_scale, max_scale), k)
					
					# rotacion "boing" mientras entra
					var phase = (anim_time / animation_duration) * oscillations * PI * 2.0
					sprite.rotation = original_rotation + sin(phase) * deg2rad(max_rotation_degrees)
					
					if t >= 1.0:
						anim_state = AnimState.HOVER
						anim_time = 0.0
						# asegurar rotacion quieta en hover
						sprite.rotation = original_rotation
				
				AnimState.HOVER:
					# escala fija en max
					sprite.scale = Vector2(max_scale, max_scale)
					# rotacion fija en original
					sprite.rotation = original_rotation
				
				AnimState.EXIT:
					var t = clamp(anim_time / (animation_duration * 0.5), 0.0, 1.0)
					var k = 1.0 - sin(t * PI * 0.5)
					sprite.scale = original_scale.linear_interpolate(Vector2(max_scale, max_scale), k)
					
					# rotacion "boing" mientras sale
					var phase = (anim_time / animation_duration) * oscillations * PI * 2.0
					sprite.rotation = original_rotation + sin(phase) * deg2rad(max_rotation_degrees)
					
					if t >= 1.0:
						sprite.scale = original_scale
						sprite.rotation = original_rotation
						anim_state = AnimState.IDLE
						anim_time = 0.0


func get_average_color_from_sprite(sprite: Sprite) -> Color:
	var tex = sprite.texture
	if tex == null:
		return Color(0, 0, 0)
	
	var img = tex.get_data()
	img.lock()
	
	var col = Color(0, 0, 0)
	var count = 0
	
	var rect = sprite.region_rect if sprite.region_enabled else Rect2(Vector2(0,0), img.get_size())
	
	var start_x = int(rect.position.x)
	var start_y = int(rect.position.y)
	var end_x = int(rect.position.x + rect.size.x)
	var end_y = int(rect.position.y + rect.size.y)
	
	for x in range(start_x, end_x):
		for y in range(start_y, end_y):
			var px = img.get_pixel(x, y)
			if px.a > 0.1: # ignora transparente o casi
				col += Color(px.r, px.g, px.b, 1.0) # ignoramos alfa al sumar
				count += 1
	
	img.unlock()
	
	if count == 0:
		return Color(0, 0, 0) # todo transparente
	return col / count


func get_mixed_color(sprite: Sprite) -> Color:
	var main_color = get_average_color_from_sprite(sprite)
	
	var puntitos_node = sprite.get_node_or_null("Puntitos")
	if puntitos_node and puntitos_node.get_child_count() > 0:
		var puntito_sprite = puntitos_node.get_child(0) as Sprite
		if puntito_sprite:
			var puntito_color = get_average_color_from_sprite(puntito_sprite)
			# mezcla ambos colores
			return (puntito_color)
	
	return main_color


func actualizar_sombra():
	var sprite = $Sprite
	var shadow = $Shadow
	
	if sprite.visible:
		$Descripcion.position.y = -97
	else:
		$Descripcion.position.y = -57
	
	# Copiar posición relativa dentro del nodo
	if get_parent().dragging == self:
		shadow.global_position = sprite.global_position + Vector2 (0, 10)
	else:
		shadow.global_position = sprite.global_position + Vector2 (0, 5)
	
	shadow.rotation = sprite.rotation
	shadow.scale = sprite.scale
	#shadow.z_index = sprite.z_index-1
	
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItem.BLEND_MODE_MIX
	shadow.material = mat
	$Pixe.visible = bool(int(!$Sprite.visible)*int(Global.mostrar_colision_dominos))
	$Parte_de_costado.position = $Sprite.position
	
	shadow.visible = sprite.visible
	
	# Copiar textura y región
	shadow.texture = sprite.texture
	shadow.region_enabled = sprite.region_enabled
	#shadow.region_rect = sprite.region_rect
	shadow.region_rect = Rect2(Vector2(16, 0), Vector2(32, 64))
	var posision = get_global_mouse_position()
	
	shadow.position = (((posision-shadow.position)/300))+Vector2(0, 10)
	
	if Global.sombras == false:
		shadow.visible = false


var valor_dragin =  null


func start_animation():
	anim_state = AnimState.ENTER
	anim_time = 0.0


func _on_mouse_entered(detector_name):
	if get_parent().dragging != self:
		if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
			mouse_over = true
			update_focus()


func _on_mouse_exited(detector_name):
	if get_parent().dragging != self:
		if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
			mouse_over = false
			$Descripcion.visible = false
			get_node("Sprite-top").material.set_shader_param('outline_size', 0)
			update_focus()


func mouse_dentro_area() -> bool:
	return mouse_over


func take_focus():
	if anim_state == AnimState.IDLE or anim_state == AnimState.EXIT:
		anim_state = AnimState.ENTER
		anim_time = 0.0
		self.get_node("Sprite").z_index = 10


func lose_focus():
	if anim_state == AnimState.ENTER or anim_state == AnimState.HOVER:
		anim_state = AnimState.EXIT 
		anim_time = 0.0
		self.get_node("Sprite").z_index = 0


func mouse_over_area(area: Area2D, scale_factor: float = 1.0) -> bool:
	var mouse_pos = get_global_mouse_position()
	
	# Asumimos que cada area tiene un solo CollisionShape2D hijo
	var shape_node = area.get_node("CollisionShape2D") as CollisionShape2D
	if shape_node == null or shape_node.shape == null:
		return false
	
	var shape = shape_node.shape
	var transform = shape_node.get_global_transform()
	
	if shape is RectangleShape2D:
		# el rect está centrado en el origen
		var rect = Rect2(-shape.extents * scale_factor, shape.extents * 2 * scale_factor)
		# convertir mouse a espacio local del shape
		var local_mouse = transform.affine_inverse().xform(mouse_pos)
		return rect.has_point(local_mouse)
		
	elif shape is CircleShape2D:
		var dist = (mouse_pos - transform.origin).length()
		return dist <= shape.radius * scale_factor
	
	return false


func update_focus():
	if get_parent().get_parent().get_parent().get_parent().baraja_activa == "baraja_especial":
		var hovered = []
		for d in get_tree().get_nodes_in_group("dominos"):
			if d.get_parent().name != "Baraja":
				if d.mouse_dentro_area():
					hovered.append(d)
		
		if hovered.size() == 0:
			for d in get_tree().get_nodes_in_group("dominos"):
				if d.get_parent().name != "Baraja":
					d.lose_focus()
			return
		
		var leftmost = hovered[0]
		for d in hovered:
			if d.get_parent().name != "Baraja":
				if d.global_position.x < leftmost.global_position.x:
					leftmost = d
		
		for d in get_tree().get_nodes_in_group("dominos"):
			if d.get_parent().name != "Baraja":
				if !get_parent().dragging:
					if d == leftmost:
						if get_parent().arrastrado != d:
							d.get_node("Descripcion").visible = true
							d.get_node("Sprite-top").material.set_shader_param('outline_size', 2)
							d.take_focus()
					else:
						d.get_node("Descripcion").visible = false
						d.get_node("Sprite-top").material.set_shader_param('outline_size', 0)
						d.lose_focus()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "aparecer":
		scale_puede_cambiar = true
		$AnimationPlayer.queue_free()
