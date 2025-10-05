extends YSort



var domino = preload("res://Scenas/Specials_tienda.tscn")

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
	mazo_original = Global.dominos_especiales.duplicate()
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



func draw_cards(n):
	var current_cards = get_children().size()
	
	if current_cards >= Global.stats.max_cards_in_hand:
		return
	
	var keys = mazo_actual.keys()
	
	if keys.size() == 0:
		return
	
	if n > keys.size():
		n = keys.size()
	
	# limitar n para que no se pase del maximo de 8
	if current_cards + n > 8:
		#print("Solo se pueden agregar %d cartas para no pasar de 8" % (8 - current_cards))
		n = 8 - current_cards
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	for _i in range(n):
		# agarramos una key random
		var index = rng.randi_range(0, keys.size() - 1)
		var nombre = keys[index]
		var _datos = mazo_actual[nombre]
		
		# crear carta
		var s = domino.instance()
		s.set_meta("base_pos", s.get_node("Sprite").position)
		s.nombre = nombre
		s.name = nombre
		s.yo = mazo_actual[nombre]
		add_child(s)
		s.global_position = Vector2(1060, 188)
		
		s.get_node("Parte_de_atras").region_rect.position = mazo_actual[nombre]["BG"]+Vector2(96, 0)
		s.get_node("Parte_de_costado").region_rect = Rect2(Vector2(245, 192), Vector2(6, 64))
		
		s.get_node("Sprite/BG").region_rect.position = mazo_actual[nombre]["BG"]
		
		if nombre == "Sniper":
			s.get_node("Sprite/BG").region_rect.position = mazo_actual[nombre]["region_rect_cords"]
			s.get_node("Parte_de_atras").region_rect.position = mazo_actual[nombre]["region_rect_cords"]
		
		if mazo_actual[nombre]["BG"].x == 4800:
			s.get_node("Sprite/BG").region_rect.position = mazo_actual[nombre]["region_rect_cords"]
			s.get_node("Parte_de_atras").region_rect.position = mazo_actual[nombre]["region_rect_cords"]
		
		s.get_node("Sprite").region_rect.position = mazo_actual[nombre]["region_rect_cords"]
		
		var base_color = get_average_color_from_sprite(s.get_node("Sprite/BG"))
		s.get_node("Parte_de_costado").material.set_shader_param("to_color2", base_color)
		s.get_node("Parte_de_costado").material.set_shader_param("to_color1", base_color)
		
		if nombre == "Sniper":
			s.get_node("Sprite/BG").region_rect.position = mazo_actual[nombre]["BG"]
		
		var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
		var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
		var costo_label   = s.get_node("Descripcion/MarginContainer/Costo/Label")
		
		titulo_label.bbcode_enabled = true
		desc_label.bbcode_enabled   = true
		costo_label.bbcode_enabled  = true
		
		titulo_label.bbcode_text = "[center]%s[/center]" % parsear_colores_bbcode(mazo_actual[nombre]["titulo"])
		desc_label.bbcode_text   = "[center]%s[/center]" % parsear_colores_bbcode(mazo_actual[nombre]["descripcion"])
		costo_label.bbcode_text  = "[center]%s[/center]" % parsear_colores_bbcode(mazo_actual[nombre]["plata"]) +"[color=#b1911a]"+ Global.prefix_plata
		
		
		mazo_actual.erase(nombre)
		keys = mazo_actual.keys()


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


func parsear_colores_bbcode(texto) -> String:
	texto = str(texto)
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


func _physics_process(_delta):
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
			
			if hovered_card and hovered_card != arrastrado and !get_parent().get_node("Baraja_stamps").dragging and !get_parent().get_node("Baraja_normales").dragging:
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
					if s.position.distance_to(target_pos[s]) > 0.5: # umbral de "todavía en movimiento
						s.position = s.position.move_toward(target_pos[s], velocidad_layout)
					
					s.set_meta("moviendo", s.position.distance_to(target_pos[s]) > 0.5)
		
		
		if return_to_pos and arrastrado:
			var velocidad = 40
			arrastrado.get_node("Descripcion").visible = false
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
	if get_parent().get_parent().get_parent().baraja_activa == "baraja":
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
							dragging.get_node("Descripcion").visible = false
						
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
	
	var game_area = get_tree().root.get_node("Game/Viewport/GameArea/Area2D")

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
					
					# verificar si estan dentro o fuera del area
					a.elemento_en_juego = point_in_area(a.global_position, game_area)
					b.elemento_en_juego = point_in_area(b.global_position, game_area)
					
					if !a.elemento_en_juego:
						a.get_node("Sprite").visible = true
						a.get_node("Sprite-top").visible = false
					
					if !b.elemento_en_juego:
						b.get_node("Sprite").visible = true
						b.get_node("Sprite-top").visible = false


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
