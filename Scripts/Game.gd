extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}


var domino = preload("res://Scenas/Domino.tscn")

var mazo = {
	
}

var mover_cartas1 = true

var dragging = null
var arrastrado = null
var offset = Vector2(0,0)
var target_pos = {}
var return_to_pos = false  # indica que debe volver suavemente

onready var drop_zone_sprite = $Viewport/GameArea

var mouse_over = false  # variable que indica si el mouse está encima


func _ready():
	# Crear varios sprites para arrastrar
	for _i in range(8):
		var s = domino.instance()
		$Viewport/Baraja.add_child(s)
		s.global_position = $Viewport/Zona_de_stack.global_position+Vector2(100,0)
	
	var _a = $Viewport/GameArea/Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	_a = $Viewport/GameArea/Area2D.connect("mouse_exited", self, "_on_mouse_exited")


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


var divisor_distancia = 2

var inclinacion_max = 50.0
var velocidad_inclinacion = 0.6 # suavizado con lerp
var inclinacion_objetivo = 0.0
var last_hovered_card = null  # fuera de _physics_process



var layout_width = 400  # ancho máximo del layout
var spacing = 10        # separación mínima
var velocidad_layout = 10  # suavizado



func _physics_process(_delta):
	mover_cartas()
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	get_node("CanvasLayer/Mira/Tex_mira").frame = 2
	
	if !Global.mostrar_mouse:
		Input.mouse_mode =Input.MOUSE_MODE_HIDDEN
	
	$CanvasLayer.visible = Global.mostrar_cursor_de_game
	
	var posision = get_global_mouse_position()
	var diferenciax = 40
	var diferenciay = 20
	
	var camara = get_node("Viewport/Camera2D")
	camara.position = (((posision-camara.position)/40))
	
	#get_node("BackGround").position.x -= 0.1
	
	for i in get_node("Viewport/Menu").get_child_count():
		var boton = get_node("Viewport/Menu").get_child(i)
		if boton.name == "Quit":
			diferenciax = 40
			diferenciay = 25
		if boton.name == "Options":
			diferenciax = 50
			diferenciay = 25
		
		if boton.name == "Discord":
			diferenciax = 14
			diferenciay = 14
		
		if boton.visible != false:
			if posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax:
				if posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay:
					get_node("CanvasLayer/Mira/Tex_mira").frame = 1
					var diferencia_x_de_posisiones = abs(posision.x)-abs(boton.get_node("Play_sprites").global_position.x)
					var diferencia_y_de_posisiones = abs(boton.get_node("Play_sprites").global_position.y)-abs(posision.y)
					
					if Input.is_action_pressed("click"):
						botonHover[boton.name] = true
						if boton.name == "Quit":
							boton.global_position.y = 68
							boton.global_position.x = 180
							boton.get_node("Play_sprites/Shaw").position.y = 0
							boton.get_node("Play_sprites/Shaw").position.x = 0
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
						if boton.name == "Discord":
							boton.global_position.y = -145
							boton.global_position.x = -225
							boton.get_node("Play_sprites/Shaw").position.y = 0
							boton.get_node("Play_sprites/Shaw").position.x = 0
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.6)
						if boton.name == "Options":
							boton.global_position.y = 66
							boton.global_position.x = -40
							boton.get_node("Play_sprites/Shaw").position.y = -8
							boton.get_node("Play_sprites/Shaw").position.x = 2
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
						if boton.name == "Play":
							boton.global_position.y = 67
							boton.global_position.x = -144
							boton.get_node("Play_sprites/Shaw").position.y = -8
							boton.get_node("Play_sprites/Shaw").position.x = -1
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
					else:
						if botonHover[boton.name] == true:
							botonHover[boton.name] = false
							if boton.name == "Quit":
								get_tree().quit()
								pass
							if boton.name == "Play":
								Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
								pass
						
						if boton.name == "Quit":
							boton.global_position.y = 65
							boton.global_position.x = 178
							boton.get_node("Play_sprites/Shaw").position.y = 3
							boton.get_node("Play_sprites/Shaw").position.x = 2
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
						if boton.name == "Options":
							boton.global_position.y = 62
							boton.global_position.x = -39
							boton.get_node("Play_sprites/Shaw").position.y = -5
							boton.get_node("Play_sprites/Shaw").position.x = 1.143
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
						if boton.name == "Play":
							boton.global_position.y = 63
							boton.global_position.x = -142
							boton.get_node("Play_sprites/Shaw").position.y = -5
							boton.get_node("Play_sprites/Shaw").position.x = -2.857
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
						if boton.name == "Discord":
							boton.global_position.y = -147
							boton.global_position.x = -223
							boton.get_node("Play_sprites/Shaw").position.y = 4
							boton.get_node("Play_sprites/Shaw").position.x = -4
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					
					
					if boton.name == "Quit":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", diferencia_x_de_posisiones/8)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
					
					if boton.name == "Options":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/15)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
					
					if boton.name == "Play":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/8)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
					
					if boton.name == "Discord":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/2)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", -diferencia_y_de_posisiones/2)
					
					boton.get_node("Play_sprites/Sprite").use_parent_material = true
			if !(posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay and posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax):
				if botonHover[boton.name] == true:
					botonHover[boton.name] = false
				if boton.name == "Quit":
					boton.global_position.y = 65
					boton.global_position.x = 178
					boton.get_node("Play_sprites/Shaw").position.y = 3
					boton.get_node("Play_sprites/Shaw").position.x = 2
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				if boton.name == "Options":
					boton.global_position.y = 62
					boton.global_position.x = -39
					boton.get_node("Play_sprites/Shaw").position.y = -5
					boton.get_node("Play_sprites/Shaw").position.x = 1.143
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				if boton.name == "Play":
					boton.global_position.y = 63
					boton.global_position.x = -142
					boton.get_node("Play_sprites/Shaw").position.y = -5
					boton.get_node("Play_sprites/Shaw").position.x = -2.857
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				if boton.name == "Discord":
					boton.global_position.y = -147
					boton.global_position.x = -223
					boton.get_node("Play_sprites/Shaw").position.y = 4
					boton.get_node("Play_sprites/Shaw").position.x = -4
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			
			if !(posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay and posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax):
					boton.get_node("Play_sprites/Sprite").use_parent_material = false
	
	
	for s in $Viewport/Baraja.get_children():
		s.get_node("Sprite-top/Flechita").rotation_degrees = s.get_node("Sprite-top").material.get_shader_param("r1") * 180 / PI
	
	var hovered_card = null
	
	for s in $Viewport/Baraja.get_children():
		s.get_node("Sprite-top").visible = !s.get_node("Sprite").visible
		if s.mouse_dentro_area():
			hovered_card = s
			break
	
	if hovered_card != last_hovered_card and !dragging:
		if last_hovered_card:
			last_hovered_card.get_node("Sprite-top/Flechita/Flechita2").visible = false
		
		if hovered_card:
			hovered_card.get_node("Sprite-top/Flechita/Flechita2").visible = true
			hovered_card.start_animation()
	
	last_hovered_card = hovered_card
	
	if dragging:
		var sprite = dragging.get_node("Sprite")
		sprite.rotation_degrees = lerp(sprite.rotation_degrees, inclinacion_objetivo, velocidad_inclinacion)


	var dominos = []
	for s in $Viewport/Baraja.get_children():
		if s != dragging and s != arrastrado and s.get_node("Sprite").visible:
			dominos.append(s)
	
	
	var count = dominos.size()
	
	if dragging != null or arrastrado != null:
		count += 1  # incluimos espacio para el domino arrastrado
	
	
	if count != 0:
		var left_margin = -layout_width/2
		var right_margin = layout_width/2
		var available_space = right_margin - left_margin
		var step = available_space / max(1, count-1)
		
		# Actualizamos posiciones objetivo de la grilla
		
		for i in range(count):
			if  arrastrado == null:
				var objetivo_x = left_margin + step * i
				#print(objetivo_x)
				var objetivo = Vector2(objetivo_x, 0)  # puedes mantener Y según necesites
				if dragging != null and i == closest_slot_index():
					target_pos[dragging] = objetivo
					continue
				
				
				var index = i
				if dragging != null and i > closest_slot_index():
					index = i - 1
				var s = dominos[index]
				
				target_pos[s] = objetivo
		
		
		for s in dominos:
			if target_pos.has(s):
				s.position = s.position.move_toward(target_pos[s], velocidad_layout)
	
	
	if return_to_pos and arrastrado:
		var velocidad = 40
		arrastrado.position = arrastrado.position.move_toward(target_pos[arrastrado], velocidad)
		
		var velocidad_x = velocidad
		var inclinacion_objetivo1 = clamp(velocidad_x/10, -inclinacion_max, inclinacion_max)
		
		arrastrado.get_node("Sprite").rotation_degrees = lerp(
			arrastrado.get_node("Sprite").rotation_degrees,
			inclinacion_objetivo1, # inverso para que coincida con dirección
			velocidad_inclinacion
		)
		
		if arrastrado.position.distance_to(target_pos[arrastrado]) < 5:
			arrastrado.get_node("Sprite").rotation_degrees = 0
			arrastrado.position = target_pos[arrastrado]
			return_to_pos = false
			arrastrado = null
			sort_children_by_x($Viewport/Baraja)


export(float) var amplitude = 5.0
export(float) var speed = 2.0
export(float) var rotation_amount = 3.0 # degrees of rotation for the middle letter
export(float) var rotation_speed = 1.5  # speed of rotation
export(float) var rotation_offset = 90.0 # base rotation in degrees

var letters = []


func mover_cartas():
	if mover_cartas1:
		# Get all child letters (run only once)
		if letters.empty():
			letters = $Viewport/Baraja.get_children()
			for letter in letters:
				# Store initial position in metadata
				letter.set_meta("base_pos", letter.get_node("Sprite").position)
		
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
			if children[i].position.x > children[j].position.x:
				var temp = children[i]
				children[i] = children[j]
				children[j] = temp
	
	for i in range(children.size()):
		parent_node.move_child(children[i], i)


func sort_children_by_x_desc(parent_node: Node) -> void:
	var children = parent_node.get_children()
	
	for i in range(children.size()):
		for j in range(i + 1, children.size()):
			if children[i].position.x < children[j].position.x:
				var temp = children[i]
				children[i] = children[j]
				children[j] = temp
	
	for i in range(children.size()):
		parent_node.move_child(children[i], i)


func closest_slot_index():
	var dominos = $Viewport/Baraja.get_children()
	var mouse_x = get_global_mouse_position().x
	
	# Filtramos el arrastrado
	var filtered = []
	for d in dominos:
		if d != dragging and d.get_node("Sprite").visible:
			filtered.append(d)
	
	var count = filtered.size() + 1  # +1 para permitir slot al final
	
	# Calculamos slots basados en posición de dominos
	var slots = []
	for i in range(count):
		if i == 0:
			# Primer slot antes del primer domino
			if filtered.size() > 0:
				slots.append(filtered[0].global_position.x - filtered[0].get_node("Sprite").texture.get_size().x/2)
			else:
				slots.append(0)
		elif i == count - 1:
			# Último slot después del último domino
			slots.append(filtered[-1].global_position.x + filtered[-1].get_node("Sprite").texture.get_size().x/2)
		else:
			# Slot entre dominos
			var prev = filtered[i - 1]
			var next = filtered[i]
			var mid = (prev.global_position.x + next.global_position.x) / 2
			slots.append(mid)
	
	# Encontrar el slot más cercano al mouse
	var closest = 0
	var min_dist = INF
	for i in range(slots.size()):
		var dist = abs(mouse_x - slots[i])
		if dist < min_dist:
			min_dist = dist
			closest = i
	
	return closest


func _input(event):
	if event is InputEventMouseButton:
		# Click izquierdo
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				for s in $Viewport/Baraja.get_children():
					if s != arrastrado:
						# Verificamos si el mouse está dentro del "círculo" del sprite
						if s.mouse_dentro_area():
							dragging = s
							dragging.get_node("Sprite").z_as_relative = false
							dragging.get_node("Sprite").z_index = 10
							if s.get_node("Sprite").visible:
								target_pos[s] = s.global_position
							return_to_pos = false
							break
					
			else:
				if dragging:
					if dragging.get_node("Sprite").visible:
						return_to_pos = true
						arrastrado = dragging
					dragging.get_node("Sprite").z_as_relative = false
					dragging.get_node("Sprite").z_index = 0
					
					# ✅ Resetear inclinación suavemente al soltar
					dragging.get_node("Sprite").rotation_degrees = 0
					
					dragging = null
		
		# Rueda del mouse
		
			if event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed():
				dragging.get_node("Sprite-top").material.set_shader_param(
					"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") + 0.25
				)
			elif event.button_index == BUTTON_WHEEL_UP and event.is_pressed():
				dragging.get_node("Sprite-top").material.set_shader_param(
					"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") - 0.25
				)
		
	# Teclas opcionales para rotar sin rueda
	elif event is InputEventKey and dragging and event.is_pressed() and !dragging.get_node("Sprite").visible:
		if event.scancode == KEY_LEFT or event.scancode == KEY_A:
			dragging.get_node("Sprite-top").material.set_shader_param(
				"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") - 0.25
			)
		elif event.scancode == KEY_RIGHT or event.scancode == KEY_D:
			dragging.get_node("Sprite-top").material.set_shader_param(
				"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") + 0.25
			)
		
	elif event is InputEventMouseMotion and dragging:
		# --- Movimiento principal ---
		dragging.global_position = get_global_mouse_position() + offset
		dragging.get_node("Sprite").visible = !is_over_drop_zone()
		
		# --- Inclinación basada en velocidad del mouse ---
		var velocidad_x = event.relative.x
		var inclinacion_objetivo1 = clamp(velocidad_x, -inclinacion_max, inclinacion_max)
		
		dragging.get_node("Sprite").rotation_degrees = lerp(
			dragging.get_node("Sprite").rotation_degrees,
			inclinacion_objetivo1, # inverso para que coincida con dirección
			velocidad_inclinacion
		)
		
		# --- REPULSION ENTRE ELEMENTOS ---
		if !dragging.get_node("Sprite").visible:
			for s in $Viewport/Baraja.get_children():
				if s == dragging:
					continue
				if !s.get_node("Sprite").visible:
					var dir = dragging.global_position - s.global_position
					var dist = dir.length()
					
					var distancia_de_repelerse = 15
					
					if dist < distancia_de_repelerse:  # distancia mínima de repulsión
						dir = dir.normalized()
						dragging.global_position += dir * (distancia_de_repelerse - dist) * 1
				


func is_over_drop_zone():
	return mouse_over

