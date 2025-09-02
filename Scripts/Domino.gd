extends Node2D


export var max_scale = 2.4
export var max_rotation_degrees = 5.0
var oscillations = 1
var animation_duration = 0.6
var animation_speed = 3
var is_animating = false
var animation_timer = 0.0
var original_scale = Vector2(2,2)
var original_rotation = 0.0
var nombre = "rojo_8"


func _ready():
	original_scale = get_node("Sprite").scale
	original_rotation = get_node("Sprite").rotation

	get_node("Sprite-top").material = get_node("Sprite-top").material.duplicate()
	if Global.METODO_DE_CAIDA == "3d":
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 1)
	else:
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 0)

	# Conectar ambos detectores al mismo método
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
		"azul":
			region_pos = Vector2(0,64)
		"verde":
			region_pos = Vector2(0,80)
		"amarillo":
			region_pos = Vector2(0,96)
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
		# posición relativa dentro de Puntitos
		punto.position = Vector2(col * spacing_x, fila * spacing_y)
		puntitos_node.add_child(punto)


func start_animation():
	if !is_animating:
		animation_timer = animation_duration
	is_animating = true


func _process(delta):
	#print($Sprite/Puntitos.get_child_count())
	if is_animating:
		animation_timer -= delta * animation_speed
		if animation_timer > 0:
			var t = 1.0 - (animation_timer / animation_duration)
			
			get_node("Sprite").scale = original_scale.linear_interpolate(Vector2(max_scale, max_scale), sin(t * PI))
			
			var oscillation_factor = sin(t * oscillations * PI * 2)
			get_node("Sprite").rotation = original_rotation + oscillation_factor * deg2rad(max_rotation_degrees)
		else:
			get_node("Sprite").scale = original_scale
			get_node("Sprite").rotation = original_rotation
			is_animating = false


var mouse_over = false  # indicador si el mouse está dentro


func _on_mouse_entered(detector_name):
	if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
		mouse_over = true

func _on_mouse_exited(detector_name):
	if (detector_name == "detector2" and $Sprite.visible) or (detector_name == "detector3" and !$Sprite.visible):
		mouse_over = false


func mouse_dentro_area() -> bool:
	return mouse_over



