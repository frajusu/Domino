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
var nombre = "rojo_8"

enum AnimState { IDLE, ENTER, HOVER, EXIT }
var anim_state = AnimState.IDLE
var anim_time = 0.0

var mouse_over = false  # indicador si el mouse esta dentro


func _ready():
	original_scale = get_node("Sprite").scale
	original_rotation = get_node("Sprite").rotation
	
	get_node("Sprite-top").material = get_node("Sprite-top").material.duplicate()
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
	
	var base_color = get_average_color_from_sprite(get_node("Sprite"))
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
			col += img.get_pixel(x, y)
			count += 1
	
	img.unlock()
	return col / count


func crear_puntitos():
	$Sprite.texture = preload("res://assets/tex/dominos.png")
	$Sprite.region_enabled = true
	$Sprite.region_rect = Rect2(Global.dominos[nombre]["region_rect_cords"], Global.dominos[nombre]["region_rect_size"])
	
	var domino_data = Global.dominos.get(nombre, null)
	if domino_data == null:
		return
	
	if domino_data["puntaje"] <= 0:
		return
	
	var puntitos_node = $Sprite/Puntitos
	for child in puntitos_node.get_children():
		child.queue_free()
	
	var puntito_tex = preload("res://assets/tex/dominos.png")
	
	var color = nombre.split("_")[0]
	var region_pos = Vector2(0,0)
	var region_size = Vector2(16,16)
	
	match color:
		"rojo":
			region_pos = Vector2(0,48)
			$Sprite.material.set_shader_param("to_color", Color("#f3983a"))
		"azul":
			region_pos = Vector2(0,64)
			$Sprite.material.set_shader_param("to_color", Color("#f6bbaf"))
		"verde":
			region_pos = Vector2(0,80)
			$Sprite.material.set_shader_param("to_color", Color("#3c4368"))
		"amarillo":
			region_pos = Vector2(0,96)
			$Sprite.material.set_shader_param("to_color", Color("#235955"))
		_:
			region_pos = Vector2(0,0)
	
	region_size = Vector2(16,16)
	
	# Grid de 2 columnas
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
		# posicion relativa dentro de Puntitos
		punto.position = Vector2(col * spacing_x, fila * spacing_y)
		puntitos_node.add_child(punto)


func start_animation():
	anim_state = AnimState.ENTER
	anim_time = 0.0


onready var cam = get_tree().get_nodes_in_group("camera")[0]

func _process(delta):
	update_description()
	
	if anim_state != AnimState.IDLE:
		anim_time += delta * animation_speed
	
	var sprite = get_node("Sprite")
	
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


func update_description():
	#$Descripcion/MarginContainer/Descripcion/NinePatchRect.rect_size = $Descripcion/MarginContainer/Descripcion/Label.rect_size+Vector2(20,20)
	#$Descripcion/MarginContainer/Titulo/NinePatchRect.rect_size = $Descripcion/MarginContainer/Titulo/Label.rect_size+Vector2(20,15)
	$CanvasLayer/Descripcion/MarginContainer/Fondo/NinePatchRect.rect_size.y = $CanvasLayer/Descripcion/MarginContainer/Descripcion/Label.rect_size.y+Vector2(20,20).y + $CanvasLayer/Descripcion/MarginContainer/Titulo/Label.rect_size.y+Vector2(20,37).y
	$CanvasLayer/Descripcion.position.y = -10-($CanvasLayer/Descripcion/MarginContainer/Fondo/NinePatchRect.rect_size.y/2)


func _on_mouse_entered(detector_name):
	if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
		mouse_over = true
		$CanvasLayer/Descripcion.visible = true
		update_focus()


func _on_mouse_exited(detector_name):
	if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
		mouse_over = false
		$CanvasLayer/Descripcion.visible = false
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
		if d == leftmost:
			d.take_focus()
		else:
			d.lose_focus()
