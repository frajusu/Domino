extends YSort



var domino = preload("res://Scenas/Domino.tscn")

var mazo = Global.dominos

var mover_cartas1 = true

var dragging = null
var arrastrado = null
var offset = Vector2(0,0)
var target_pos = {}
var return_to_pos = false  # indica que debe volver suavemente

var mouse_over = false  # variable que indica si el mouse está encima


func _ready():
	draw_cards(8)
	var _a = get_parent().get_node("GameArea/Area2D").connect("mouse_entered", self, "_on_mouse_entered")
	_a = get_parent().get_node("GameArea/Area2D").connect("mouse_exited", self, "_on_mouse_exited")


func _on_mouse_entered():
	mouse_over = true


func _on_mouse_exited():
	mouse_over = false


var divisor_distancia = 2

var inclinacion_max = 50.0
var velocidad_inclinacion = 0.6 # suavizado con lerp
var inclinacion_objetivo = 0.0
var last_hovered_card = null    # fuera de _physics_process



var layout_width = 470     # ancho máximo del layout
var spacing = 10           # separación mínima
var velocidad_layout = 10  # suavizado



func draw_cards(n):
	# revisar cuantos dominos ya hay en este nodo
	var current_cards = get_children().size()
	
	if current_cards >= Global.stats.max_cards_in_hand:
		print("Ya tienes ",Global.stats.max_cards_in_hand," cartas en juego, no se pueden agregar mas")
		return
	
	var keys = mazo.keys()
	
	if keys.size() == 0:
		print("No quedan cartas en el mazo")
		return
	
	if n > keys.size():
		print("No vas a poder sacar mas, solo quedan %d cartas" % keys.size())
		n = keys.size()
	
	# limitar n para que no se pase del maximo de 8
	if current_cards + n > 8:
		print("Solo se pueden agregar %d cartas para no pasar de 8" % (8 - current_cards))
		n = 8 - current_cards
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for _i in range(n):
		# agarramos una key random
		var index = rng.randi_range(0, keys.size() - 1)
		var nombre = keys[index]
		var _datos = mazo[nombre]
		
		# crear carta
		var s = domino.instance()
		s.nombre = nombre
		add_child(s)
		s.global_position = Vector2(210, 150)
		
		# ejemplo si tu carta acepta datos
		# s.set_datos(_datos)
		
		# borrar del mazo
		mazo.erase(nombre)
		keys = mazo.keys()  # actualizar keys porque el mazo cambio


func _physics_process(_delta):
	if get_parent().get_parent().baraja_activa == "baraja":
		get_parent().get_node("Zona_de_baraja/Cartas_Actuales").text = str(get_child_count())
		get_parent().get_node("Zona_de_baraja/Cartas_Max").text = str(Global.stats.max_cards_in_hand)
		
		mover_cartas()
		
		var hovered_card = null
		
		for s in get_children():
			if s.scale_puede_cambiar:
				if dragging != s:
					s.scale = Vector2(1,1)
				else:
					s.scale = Vector2(1.1,1.1)
			
			s.get_node("Sprite-top").visible = !s.get_node("Sprite").visible
			if s.mouse_dentro_area():
				hovered_card = s
				break
		
		if hovered_card != last_hovered_card and !dragging:
			#if last_hovered_card and is_instance_valid(last_hovered_card):
			#	last_hovered_card.get_node("Sprite-top").material.set_shader_param('outline_size', 0)
			
			if hovered_card:
				#hovered_card.get_node("Sprite-top").material.set_shader_param('outline_size', 2)
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


		var dominos = []
		for s in get_children():
			if s != dragging and s != arrastrado and s.get_node("Sprite").visible:
				dominos.append(s)
		
		
		var count = dominos.size()
		
		if dragging != null or arrastrado != null:
			count += 1  # incluimos espacio para el domino arrastrado
		
		
		if count != 0:
			var left_margin = -layout_width/2
			var right_margin = layout_width/2
			var available_space = right_margin - left_margin
			var step = available_space / count
			var start_x = left_margin + step / 2
			
			for i in range(count):
				if  arrastrado == null:
					var objetivo_x = start_x + step * i
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
			
			arrastrado.rotation_degrees = lerp(
				arrastrado.rotation_degrees,
				inclinacion_objetivo1, # inverso para que coincida con dirección
				velocidad_inclinacion
			)
			
			if arrastrado.position.distance_to(target_pos[arrastrado]) < 5:
				arrastrado.rotation_degrees = 0
				arrastrado.position = target_pos[arrastrado]
				return_to_pos = false
				arrastrado = null
				sort_children_by_x((self))


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
			letters = get_children()
			for letter in letters:
				# Store initial position in metadata
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
	var dominos = get_children()
	var mouse_x = get_global_mouse_position().x
	
	# Filtramos los visibles y que no sean el arrastrado
	var filtered = []
	for d in dominos:
		if d != dragging and d.get_node("Sprite").visible:
			filtered.append(d)
	
	var count = filtered.size() + 1  # +1 slot extra al final
	var slots = []
	
	for i in range(count):
		if i == 0:
			# Slot antes del primero
			if filtered.size() > 0:
				var sprite = filtered[0].get_node("Sprite")
				var ancho = sprite.region_rect.size.x if sprite.region_enabled else sprite.texture.get_size().x
				slots.append(filtered[0].global_position.x - ancho)
			else:
				slots.append(0)
		elif i == count - 1:
			# Slot después del último
			var sprite = filtered[-1].get_node("Sprite")
			var ancho = sprite.region_rect.size.x if sprite.region_enabled else sprite.texture.get_size().x
			slots.append(filtered[-1].global_position.x + ancho)
		else:
			# Slot intermedio
			var prev = filtered[i - 1]
			var next = filtered[i]
			var mid = (prev.global_position.x + next.global_position.x) / 2
			slots.append(mid)
	
	# Buscar el slot más cercano
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
				for s in get_children():
					if s != arrastrado:
						# Verificamos si el mouse está dentro del "círculo" del sprite
						if s.mouse_dentro_area():
							dragging = s
							dragging.get_node("Sprite").z_as_relative = false
							dragging.get_node("Sprite").z_index = 10
							offset = dragging.global_position-get_global_mouse_position()
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
					dragging.rotation_degrees = 0
					
					dragging = null
		
		if event.button_index == BUTTON_RIGHT:
			if event.pressed:
				for s in get_children():
					if s != arrastrado:
						# Verificamos si el mouse está dentro del "círculo" del sprite
						if s.mouse_dentro_area():
							s.get_node("Sprite").visible = true
							s.get_node("Sprite-top").visible = false
		
		if dragging and !dragging.get_node("Sprite").visible:
			if event.button_index == BUTTON_WHEEL_UP and event.pressed:
				dragging.get_node("Sprite-top").rotation_degrees += 5
			elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
				dragging.get_node("Sprite-top").rotation_degrees -= 5
	
	# Teclas opcionales para rotar sin rueda
	elif event is InputEventKey and dragging and event.is_pressed() and !dragging.get_node("Sprite").visible:
		if event.scancode == KEY_LEFT or event.scancode == KEY_A:
			dragging.get_node("Sprite-top").rotation_degrees -= 5
		elif event.scancode == KEY_RIGHT or event.scancode == KEY_D:
			dragging.get_node("Sprite-top").rotation_degrees += 5
		
	elif event is InputEventMouseMotion and dragging:
		# --- Movimiento principal ---
		dragging.get_node("Sprite").visible = !is_over_drop_zone()
		
		if Global.usar_offset:
			if dragging.get_node("Sprite").visible:
				dragging.global_position = get_global_mouse_position() + offset
			else:
				dragging.global_position = get_global_mouse_position() + Vector2(0.5, 4)
		else:
			if dragging.get_node("Sprite").visible:
				dragging.global_position = get_global_mouse_position()
		
		# --- Inclinación basada en velocidad del mouse ---
		var velocidad_x = event.relative.x
		var inclinacion_objetivo1 = clamp(velocidad_x, -inclinacion_max, inclinacion_max)
		
		dragging.rotation_degrees = lerp(
			dragging.rotation_degrees,
			inclinacion_objetivo1, # inverso para que coincida con dirección
			velocidad_inclinacion
		)
		
		# --- REPULSION ENTRE ELEMENTOS ---
		aplicar_repulsion_global()


func aplicar_repulsion_global():
	var distancia_de_repelerse = 15
	var iteraciones = 6  # mas iteraciones = menos solapamiento
	
	var dominos = []
	for s in get_children():
		if !s.get_node("Sprite").visible:
			dominos.append(s)
			s.get_node("Pixe").scale = Vector2(distancia_de_repelerse,distancia_de_repelerse)
	if dragging and !dragging.get_node("Sprite").visible:
		dominos.append(dragging)
	
	for _i in range(iteraciones):
		for a in dominos:
			for b in dominos:
				if a == b:
					continue
				var dir = a.global_position - b.global_position
				var dist = dir.length()
				if dist < distancia_de_repelerse and dist > 0.001:
					dir = dir.normalized()
					var corr = (distancia_de_repelerse - dist) * 0.5
					a.global_position += dir * corr
					b.global_position -= dir * corr
					
					if !a.elemento_en_juego:
						a.get_node("Sprite").visible = true
						a.get_node("Sprite-top").visible = false
					
					if !b.elemento_en_juego:
						b.get_node("Sprite").visible = true
						b.get_node("Sprite-top").visible = false


func is_over_drop_zone():
	return mouse_over
