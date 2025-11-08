extends GridContainer



var stamp = preload("res://Scenas/Stamps.tscn")

var mazo_original
var mazo_actual

var letters = []

var mover_cartas1 = true

var dragging = null
var arrastrado = null
var offset = Vector2(0,0)
var target_pos = {}
var return_to_pos = false  # indica que debe volver suavemente

var mouse_over = false  # variable que indica si el mouse está encima


func _ready():
	mazo_original = Global.stamps.duplicate()
	mazo_actual = mazo_original.duplicate()


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


var divisor_distancia = 2

var inclinacion_max = 50.0
var velocidad_inclinacion = 0.6 # suavizado con lerp
var inclinacion_objetivo = 0.0
var last_hovered_card = null    # fuera de _physics_process

var layout_width = 200     # ancho máximo del layout
var spacing = 10           # separación mínima
var velocidad_layout = 10  # suavizado


func parsear_colores_bbcode(texto: String) -> String:
	var resultado = ""
	var palabras = texto.split(" ")
	for palabra in palabras:
		if palabra.begins_with("<#") and ">" in palabra:
			var fin = palabra.find(">")
			var hex = palabra.substr(0, fin+1) # "<#FF0000>"
			hex = hex.replace("<", "").replace(">", "") # "#FF0000"
			var resto = palabra.substr(fin + 1, palabra.length() - fin - 1)
			if resto != "":
				resultado += "[color=%s]%s[/color]" % [hex, resto]
			else:
				resultado += "[color=%s]%s[/color]" % [hex, hex] # fallback
		else:
			resultado += palabra
		resultado += " "
	return resultado.strip_edges()


#func _input(event):
#	if get_tree().root.get_node("Game").baraja_activa == "baraja":
#		if event is InputEventMouseButton:
#			# Click izquierdo
#			if event.button_index == BUTTON_LEFT:
#				if event.pressed:
#					for s in get_children():
#						if s != arrastrado:
#							# Verificamos si el mouse está dentro del "círculo" del sprite
#							if s.mouse_dentro_area():
#								dragging = s
#								dragging.get_node("Sprite").z_as_relative = false
#								dragging.get_node("Sprite").z_index = 10
#								offset = dragging.global_position-get_global_mouse_position()
#								if s.get_node("Sprite").visible:
#									target_pos[s] = s.global_position
#								return_to_pos = false
#								break
#				else:
#					if dragging:
#						if dragging.get_node("Sprite").visible:
#							return_to_pos = true
#							arrastrado = dragging
#							dragging.get_node("Descripcion").visible = false
#
#						dragging.get_node("Sprite").z_as_relative = false
#						dragging.get_node("Sprite").z_index = 0
#
#						# ✅ Resetear inclinación suavemente al soltar
#						dragging.rotation_degrees = 0
#
#						dragging = null
#
#			if event.button_index == BUTTON_RIGHT:
#				if event.pressed:
#					for s in get_children():
#						if s != arrastrado:
#							# Verificamos si el mouse está dentro del "círculo" del sprite
#							if s.mouse_dentro_area():
#								s.get_node("Sprite").visible = true
#								s.get_node("Sprite-top").visible = false
#
#			if dragging and !dragging.get_node("Sprite").visible:
#				if event.button_index == BUTTON_WHEEL_UP and event.pressed:
#					dragging.get_node("Sprite-top").rotation_degrees += 5
#				elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
#					dragging.get_node("Sprite-top").rotation_degrees -= 5
#
#		# Teclas opcionales para rotar sin rueda
#		elif event is InputEventKey and dragging and event.is_pressed() and !dragging.get_node("Sprite").visible:
#			if event.scancode == KEY_LEFT or event.scancode == KEY_A:
#				dragging.get_node("Sprite-top").rotation_degrees -= 5
#			elif event.scancode == KEY_RIGHT or event.scancode == KEY_D:
#				dragging.get_node("Sprite-top").rotation_degrees += 5
#
#		elif event is InputEventMouseMotion and dragging:
#			# --- Movimiento principal ---
#			dragging.get_node("Sprite").visible = !is_over_drop_zone()
#
#			if Global.usar_offset:
#				if dragging.get_node("Sprite").visible:
#					dragging.global_position = get_global_mouse_position() + offset
#				else:
#					dragging.global_position = get_global_mouse_position() + Vector2(0.5, 4)
#			else:
#				if dragging.get_node("Sprite").visible:
#					dragging.global_position = get_global_mouse_position()
#
#			# --- Inclinación basada en velocidad del mouse ---
#			var velocidad_x = event.relative.x
#			var inclinacion_objetivo1 = clamp(velocidad_x, -inclinacion_max, inclinacion_max)
#
#			dragging.rotation_degrees = lerp(
#				dragging.rotation_degrees,
#				inclinacion_objetivo1, # inverso para que coincida con dirección
#				velocidad_inclinacion
#			)


func _physics_process(_delta):
		mouse_filter = Control.MOUSE_FILTER_IGNORE
		
		mover_cartas()
		
		var hovered_card = null
		
		for s in get_children():
			if s.scale_puede_cambiar:
				if dragging != s:
					s.rect_scale = Vector2(1,1)
				else:
					s.rect_scale = Vector2(1.1,1.1)
			
			s.get_node("Sprite-top").visible = !s.get_node("Sprite").visible
			if s.mouse_dentro_area():
				hovered_card = s
				break
		
		if hovered_card != last_hovered_card and !dragging:
			#if last_hovered_card and is_instance_valid(last_hovered_card):
			#	last_hovered_card.get_node("Sprite-top").material.set_shader_param('outline_size', 0)
			
			if hovered_card and hovered_card != arrastrado:
				if not hovered_card.get_meta("moviendo", false):
					hovered_card.start_animation()
		
		last_hovered_card = hovered_card
		
		if dragging:
			var sprite = dragging
			if sprite.get_node("Sprite").visible:
				sprite.rotation_degrees = lerp(sprite.rotation_degrees, inclinacion_objetivo, velocidad_inclinacion)
			else:
				sprite.rotation_degrees = 0
			sprite.get_node("Descripcion").visible = false
			#sprite.get_node("Sprite-top").material.set_shader_param('outline_size', 0)


		var stamps_in_play = []
		for s in get_children():
			if s != dragging and s != arrastrado and s.get_node("Sprite").visible:
				stamps_in_play.append(s)
		
		if return_to_pos and arrastrado:
			var velocidad = 40
			arrastrado.get_node("Descripcion").visible = false
			arrastrado.rect_position = arrastrado.rect_position.move_toward(target_pos[arrastrado], velocidad)
			
			var velocidad_x = velocidad
			var inclinacion_objetivo1 = clamp(velocidad_x/10, -inclinacion_max, inclinacion_max)
			
			arrastrado.rotation_degrees = lerp(
				arrastrado.rotation_degrees,
				inclinacion_objetivo1, # inverso para que coincida con dirección
				velocidad_inclinacion
			)
			
			if arrastrado.rect_position.distance_to(target_pos[arrastrado]) < 5:
				arrastrado.rotation_degrees = 0
				arrastrado.rect_position = target_pos[arrastrado]
				return_to_pos = false
				arrastrado = null
				sort_children_by_x((self))


export(float) var amplitude = 1.0
export(float) var speed = 2.0
export(float) var rotation_amount = 3.0 # degrees of rotation for the middle letter
export(float) var rotation_speed = 1.5  # speed of rotation
export(float) var rotation_offset = 90.0 # base rotation in degrees


func mover_cartas():
	if mover_cartas1:
		# Get all child letters (run only once)
		if letters.empty():
			letters = get_children()
			for letter in letters:
				letter.set_meta("base_pos", letter.get_node("Sprite").position)
		letters = get_children()
		var time = OS.get_ticks_msec() / 1000.0 * speed
		
		for i in range(letters.size()):
			var letter = letters[i]
			var base_pos = letter.get_meta("base_pos")
			# Add phase offset for wave effect
			var phase = i * 0.5
			letter.get_node("Sprite").position.y = base_pos.y + sin(time + phase) * amplitude


func sort_children_by_x(parent_node: Node) -> void:
	var children = parent_node.get_children()
	
	for i in range(children.size()):
		for j in range(i + 1, children.size()):
			if children[i].rect_position.x > children[j].rect_position.x:
				var temp = children[i]
				children[i] = children[j]
				children[j] = temp
	
	for i in range(children.size()):
		parent_node.move_child(children[i], i)


func sort_children_by_x_desc(parent_node: Node) -> void:
	var children = parent_node.get_children()
	
	for i in range(children.size()):
		for j in range(i + 1, children.size()):
			if children[i].rect_position.x < children[j].rect_position.x:
				var temp = children[i]
				children[i] = children[j]
				children[j] = temp
	
	for i in range(children.size()):
		parent_node.move_child(children[i], i)


func point_in_area(pos: Vector2, area: Area2D, scale_factor: float = 1.0) -> bool:
	var shape_node = area.get_node("CollisionShape2D") as CollisionShape2D
	if shape_node == null or shape_node.shape == null:
		return false
	
	var shape = shape_node.shape
	var transform = shape_node.get_global_transform()
	
	if shape is RectangleShape2D:
		var rect = Rect2(-shape.extents * scale_factor, shape.extents * 2 * scale_factor)
		var local_point = transform.affine_inverse().xform(pos)
		return rect.has_point(local_point)
		
	elif shape is CircleShape2D:
		var dist = (pos - transform.origin).length()
		return dist <= shape.radius * scale_factor
	
	return false


func is_over_drop_zone():
	return mouse_over
