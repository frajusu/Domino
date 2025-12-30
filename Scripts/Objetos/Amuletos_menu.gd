extends Control

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

var nodo_vinculado = null

enum AnimState { IDLE, ENTER, HOVER, EXIT }
var anim_state = AnimState.IDLE
var anim_time = 0.0

var scale_puede_cambiar = true

var mouse_over = false  # indicador si el mouse esta dentro

var bandera_cambiar_descripcion = false

var valores_diccionario = {
	"Rose Bloom" : ["<#296e8f>50% chance for every Rose dominos that scores to <#296e8f>gain <#296e8f>+0.2 color multiplier permanently (max <#e0483e>x2). \n<#296e8f>(now <#296e8f>: <#296e8f>", 0.0],
	"Fading Luck" : ["<#296e8f>Adds <#296e8f>+80 each play, it reduces by 10 permanently after each use. \n<#296e8f>(now <#296e8f>: <#296e8f>", 80.0],
	
	"Crystal Dice" : ["<#e0483e>Mimics one random <#e0483e>charm at the start of a level <#296e8f>(temporary). <#e0483e>\n(", "null"],
	
	"Domino Surge" : {
				"rose" : 0,
				"orange" : 0,
				"blue" : 0,
				"green" : 0,
			},
	"Random Scroll" : "color",
	"Overgrowth" : {
				"rose" : 0,
				"orange" : 0,
				"blue" : 0,
				"green" : 0,
			},
}


func _ready():
	Text.preparar_rainbow_datos($Descripcion/MarginContainer/Titulo/Label, self)
	$Descripcion.visible = false
	get_node("Sprite-top").material.set_shader_param('outline_size', 0)
	original_rotation = get_node("Sprite").rotation
	
	get_node("Sprite-top").material = get_node("Sprite-top").material.duplicate()
	
	get_node("Sprite").material = get_node("Sprite").material.duplicate()
	
	if Global.METODO_DE_CAIDA == "3d":
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 1)
	else:
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 0)
	
	# Conectar ambos detectores al mismo metodo
	var _a = $detector2.connect("mouse_entered", self, "_on_mouse_entered", [ "detector2" ])
	_a = $detector2.connect("mouse_exited", self, "_on_mouse_exited", [ "detector2" ])
	
	#crear_puntitos()
	
	# opcional: aseguramos estado consistente al inicio
	update_focus()


var elemento_en_juego = false



var posision_inicial_rainbow = []
var frame = 0

var frame_print = 0


func _physics_process(delta):
		$mouse.visible = $Descripcion.visible
		
		if get_tree().current_scene.name == "Menu_Principal": $mouse.visible = false
		
		if get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().name != "xd": $mouse.visible = false
		
		var desc_label  = get_node_or_null("Descripcion/MarginContainer/Descripcion/Label")
		
		if !bandera_cambiar_descripcion:
			match nombre:
				"Rose Bloom":
					desc_label.bbcode_text = "[center]%s[/center]" % str(Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(valores_diccionario[nombre][0] + str(valores_diccionario[nombre][1]) + ")")))
				"Fading Luck":
					desc_label.bbcode_text = "[center]%s[/center]" % str(Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(valores_diccionario[nombre][0] + str(valores_diccionario[nombre][1]) + ")")))
				"Crystal Dice":
					desc_label.bbcode_text = "[center]%s[/center]" % str(Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(valores_diccionario[nombre][0] + str(valores_diccionario[nombre][1]) + ")")))
				"Random Scroll":
					desc_label.bbcode_text = "[center]%s[/center]" % str(Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(Diccionarios.amuletos[nombre].descripcion + str(valores_diccionario[nombre]) + ")")))
		
		
		
		var costo_label  = get_node_or_null("Descripcion/MarginContainer/Costo/Label")
		
		var precio_str = get_parent().mazo_original[nombre]["venta"]
		var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
		
		var descuento = Global.stats["descuento"] / 100.0
		var precio_final = int(round(precio * (1.0 - descuento)))
		
		# volvemos a poner el tag
		var precio_bbcode = "<#b1911a>" + str(precio_final)
		
		if costo_label: 
			costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(precio_bbcode)) + "[color=#b1911a]" + Global.prefix_plata
			costo_label.bbcode_enabled  = true
		
		
		if frame < 5:
			frame += 1
		else:
			frame = 0
			Text.ciclar_rainbow($Descripcion/MarginContainer/Titulo/Label, self)
		
		
		if frame_print < 50:
			frame_print += 1
		else:
			frame_print = 0
			
			if valores_diccionario.has(nombre) and false:
				print(valores_diccionario[nombre])
		
		#elemento_en_juego = mouse_over_area(get_tree().root.get_node("Game/Viewport/GameArea/Area2D"), 1)
		
		
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


func actualizar_sombra():
	var sprite = $Sprite
	var shadow = $Shadow
	
	# Copiar posición relativa dentro del nodo
	if get_parent().dragging == self:
		shadow.global_position = sprite.global_position + Vector2 (0, 1)
	else:
		shadow.global_position = sprite.global_position + Vector2 (0, 1)
	
	shadow.rotation = sprite.rotation
	shadow.scale = sprite.scale
	shadow.z_index = sprite.z_index
	
	var mat = CanvasItemMaterial.new()
	mat.blend_mode = CanvasItem.BLEND_MODE_MIX
	shadow.material = mat
	#$Pixe.visible = bool(int(!$Sprite.visible)*int(Global.mostrar_colision_dominos))
	#$Parte_de_costado.position = $Sprite.position
	
	if get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().name == "xd":
		$Descripcion.position.x = -120
	
	if get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().name == "xd" or get_parent().get_parent().get_parent().get_parent().get_parent().get_parent().name == "Menu_info":
		if !(rect_position.x == 0 or rect_position.x == 62) and get_tree().root.has_node("Menu_Principal"):
			$Descripcion.position.x = -120
		if $Descripcion/MarginContainer.has_node("Costo"):
			$Descripcion/MarginContainer/Costo.free()
	
	var diferenciaa = 25
	
	if get_parent().dragging != self:
		var limite = get_parent().get_parent().get_parent().get_parent()
		var limite_y = limite.rect_global_position.y + limite.rect_size.y - diferenciaa
		
		var actual = $Descripcion.global_position.y
		
		# si pasa el limite, lo empuja suavemente hacia el limite
		if $Descripcion.visible:
			if actual > limite_y:
				$Descripcion.global_position.y = lerp(actual, limite_y, 0.2)
			
			# si esta por debajo, lo sube suavemente
			elif actual < limite_y:
				$Descripcion.global_position.y = lerp(actual, limite_y, 0.05)
		else:
			$Descripcion.global_position.y = limite_y
	
	
	shadow.visible = sprite.visible
	
	# Copiar textura y región
	shadow.texture = sprite.texture
	shadow.region_enabled = sprite.region_enabled
	shadow.region_rect = sprite.region_rect
	var posision = get_global_mouse_position()
	
	shadow.position = (((posision-shadow.position)/300))+Vector2(0, 1)
	
	if Global.sombras == false:
		shadow.visible = false


var valor_dragin =  null


func start_animation():
	anim_state = AnimState.ENTER
	anim_time = 0.0


func _on_mouse_entered(detector_name):
	if get_parent().dragging != self:
		if (detector_name == "detector2" and $Sprite.visible):
			mouse_over = true
			update_focus()


func _on_mouse_exited(detector_name):
	if get_parent().dragging != self:
		if (detector_name == "detector2" and $Sprite.visible):
			mouse_over = false
			$Descripcion.visible = false
			get_node("Sprite-top").material.set_shader_param('outline_size', 0)
			update_focus()


func mouse_dentro_area() -> bool:
	return mouse_over


func take_focus():
	if anim_state == AnimState.IDLE or anim_state == AnimState.EXIT:
		Global.sonido_hover_dominos()
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
	if get_tree().root.has_node("Menu_Principal") or (get_tree().root.has_node("Game") and (get_tree().root.get_node("Game").estacion_actual == "nivel" or get_tree().root.get_node("Game").estacion_actual == "tienda")):
		var hovered = []
		for d in get_tree().get_nodes_in_group("charms"):
			if d.mouse_dentro_area():
				hovered.append(d)
		
		if hovered.size() == 0:
			for d in get_tree().get_nodes_in_group("charms"):
				d.lose_focus()
			return
		
		var leftmost = hovered[0]
		for d in hovered:
			if d.rect_global_position.x < leftmost.rect_global_position.x:
				leftmost = d
		
		for d in get_tree().get_nodes_in_group("charms"):
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
