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

enum AnimState { IDLE, ENTER, HOVER, EXIT }
var anim_state = AnimState.IDLE
var anim_time = 0.0

var scale_puede_cambiar = false

var mouse_over = false  # indicador si el mouse esta dentro


func _ready():
	$AnimationPlayer.play("aparecer")
	$Descripcion.visible = false
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
	
	crear_puntitos()
	
	var base_color = get_mixed_color(get_node("Sprite"))
	get_node("Sprite-top").material.set_shader_param("original_color", base_color)
	
	var dark_factor = 0.5
	var darker_color = Color(
		base_color.r * dark_factor,
		base_color.g * dark_factor,
		base_color.b * dark_factor,
		base_color.a
	)
	
	get_node("Sprite-top").material.set_shader_param("shadow_color", darker_color)
	
	# agregar al grupo para control global de focus
	add_to_group("dominos")
	
	# opcional: aseguramos estado consistente al inicio
	update_focus()


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



func parsear_colores_bbcode(texto: String) -> String:
	var resultado = ""
	var palabras = texto.split(" ")
	for palabra in palabras:
		if palabra.begins_with("<#") and ">" in palabra:
			var hex = palabra.substr(2, palabra.find(">") - 2)
			var resto = palabra.substr(palabra.find(">") + 1, palabra.length())
			resultado += "[color=%s]%s[/color] " % [hex, resto]
		else:
			resultado += palabra + " "
	return resultado.strip_edges()


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
	shadow.z_index = sprite.z_index
	
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItem.BLEND_MODE_MIX
	shadow.material = mat
	
	$Parte_de_costado.position = $Sprite.position
	
	shadow.visible = sprite.visible
	
	# Copiar textura y región
	shadow.texture = sprite.texture
	shadow.region_enabled = sprite.region_enabled
	shadow.region_rect = sprite.region_rect
	var posision = get_global_mouse_position()
	
	shadow.position = (((posision-shadow.position)/300))+Vector2(0, 10)
	
	if Global.sombras == false:
		shadow.visible = false


func crear_puntitos():
	$Sprite.texture = preload("res://assets/tex/dominos.png")
	$Sprite.region_enabled = true
	$Sprite.region_rect = Rect2(Global.dominos[nombre]["region_rect_cords"], Global.dominos[nombre]["region_rect_size"])
	
	var domino_data = Global.dominos.get(nombre, null)
	if domino_data == null:
		return
	
	if domino_data["tipo"] == "normal":
		$Parte_de_atras.texture = $Sprite.texture
		$Parte_de_atras.region_enabled = true
		$Parte_de_atras.region_rect = Rect2(Vector2(112, 192), Vector2(32, 64))
		
		$Parte_de_costado.texture = $Sprite.texture
		$Parte_de_costado.region_enabled = true
		$Parte_de_costado.region_rect = Rect2(Vector2(245, 192), Vector2(6, 64))
		pass
	
	if domino_data["puntaje"] <= 0:
		return
	
	# Limpiar puntitos anteriores
	var puntitos_node = $Sprite/Puntitos
	for child in puntitos_node.get_children():
		child.queue_free()
	
	var puntito_tex = preload("res://assets/tex/dominos.png")
	
	var color = nombre.split("_")[0]
	var region_pos = Vector2(0,0)
	var region_size = Vector2(16,16)
	
	var cambiar_desc_color = false
	
	match color:
		"rojo":
			region_pos = Vector2(0,48)
			var base_color = Color("#f3983a")
			$Sprite.material.set_shader_param("to_color", base_color)
			$Parte_de_costado.material.set_shader_param("to_color", base_color)
			if cambiar_desc_color:
				$Descripcion.material.set_shader_param("color", base_color.linear_interpolate(Color(0.5,0.5,0.5), 0.5))
		"azul":
			region_pos = Vector2(0,64)
			var base_color = Color("#f6bbaf")
			$Sprite.material.set_shader_param("to_color", base_color)
			$Parte_de_costado.material.set_shader_param("to_color", base_color)
			if cambiar_desc_color:
				$Descripcion.material.set_shader_param("color", base_color.linear_interpolate(Color(0.5,0.5,0.5), 0.5))
		"verde":
			region_pos = Vector2(0,80)
			var base_color = Color("#3c4368")
			$Sprite.material.set_shader_param("to_color", base_color)
			$Parte_de_costado.material.set_shader_param("to_color", base_color)
			if cambiar_desc_color:
				$Descripcion.material.set_shader_param("color", base_color.linear_interpolate(Color(0.5,0.5,0.5), 0.5))
		"amarillo":
			region_pos = Vector2(0,96)
			var base_color = Color("#235955")
			$Sprite.material.set_shader_param("to_color", base_color)
			$Parte_de_costado.material.set_shader_param("to_color", base_color)
			if cambiar_desc_color:
				$Descripcion.material.set_shader_param("color", base_color.linear_interpolate(Color(0.5,0.5,0.5), 0.5))
		_:
			region_pos = Vector2(0,0)
			$Descripcion.material.set_shader_param("color", Color.gray)
	
	region_size = Vector2(16,16)
	
	# Grid de 2 columnas para puntitos
	var cols = 2
	var spacing_x = 12
	var spacing_y = 15
	
	for i in range(domino_data["puntaje"]):
		var fila = i / cols
		var col = i % cols
		var punto = Sprite.new()
		punto.texture = puntito_tex
		punto.region_enabled = true
		punto.region_rect = Rect2(region_pos, region_size)
		punto.position = Vector2(col * spacing_x, fila * spacing_y)
		puntitos_node.add_child(punto)
	
	# Poner titulo y descripcion en BBCode
	var titulo_label = $Descripcion/MarginContainer/Titulo/Label
	var desc_label   = $Descripcion/MarginContainer/Descripcion/Label
	
	titulo_label.bbcode_enabled = true
	desc_label.bbcode_enabled   = true
	
	titulo_label.bbcode_text = "[center]%s[/center]" % parsear_colores_bbcode(domino_data["titulo"])
	desc_label.bbcode_text   = "[center]%s[/center]" % parsear_colores_bbcode(domino_data["descripcion"])


var valor_dragin =  null


func start_animation():
	anim_state = AnimState.ENTER
	anim_time = 0.0


var frames = 0


func _process(delta):
	frames += 1
	
	if frames > 50:
		update_focus()
		frames = 0
	
	if valor_dragin != get_parent().dragging:
		update_focus()
		valor_dragin = get_parent().dragging
	
	actualizar_sombra()
	
	if anim_state != AnimState.IDLE:
		anim_time += delta * animation_speed
	
	var sprite = get_node("Sprite")
	
	if scale_puede_cambiar:
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
			update_focus()


func mouse_dentro_area() -> bool:
	return mouse_over


func take_focus():
	if anim_state == AnimState.IDLE or anim_state == AnimState.EXIT:
		anim_state = AnimState.ENTER
		anim_time = 0.0
		self.get_node("Sprite").z_index = 1


func lose_focus():
	if anim_state == AnimState.ENTER or anim_state == AnimState.HOVER:
		anim_state = AnimState.EXIT
		anim_time = 0.0
		self.get_node("Sprite").z_index = 0


func update_focus():
	var hovered = []
	for d in get_tree().get_nodes_in_group("dominos"):
		if d.mouse_dentro_area():
			hovered.append(d)
	
	if hovered.size() == 0:
		for d in get_tree().get_nodes_in_group("dominos"):
			d.lose_focus()
		return
	
	var leftmost = hovered[0]
	for d in hovered:
		if d.global_position.x < leftmost.global_position.x:
			leftmost = d
	
	for d in get_tree().get_nodes_in_group("dominos"):
		if !get_parent().dragging:
			if d == leftmost:
				d.get_node("Descripcion").visible = true
				d.take_focus()
			else:
				d.get_node("Descripcion").visible = false
				d.lose_focus()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "aparecer":
		scale_puede_cambiar = true
		$AnimationPlayer.queue_free()
