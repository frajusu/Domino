extends YSort



var stamp = preload("res://Scenas/Stamps_seleccion.tscn")

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
	mazo_original = Diccionarios.stamps.duplicate()
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


#func draw_stamps(n):
#	var current_stamps = get_children().size()
#	if current_stamps >= Global.stats.max_cards_in_hand:
#		return
#
#	var keys = mazo_actual.keys()
#	if keys.size() == 0:
#		return
#
#	if n > keys.size():
#		n = keys.size()
#
#	if current_stamps + n > 8:
#		n = 8 - current_stamps
#
#	var rng = RandomNumberGenerator.new()
#	rng.randomize()
#
#	for _i in range(n):
#		# Calcular chance total
#		var total_chance = 0
#		for nombre in keys:
#			total_chance += mazo_actual[nombre]["chance"]
#
#		# Tirar dado de probabilidad
#		var roll = rng.randf_range(0, total_chance)
#		var acumulado = 0
#		var nombre_seleccionado = keys[0]
#
#		for nombre in keys:
#			acumulado += mazo_actual[nombre]["chance"]
#			if roll <= acumulado:
#				nombre_seleccionado = nombre
#				break
#
#		var data = mazo_actual[nombre_seleccionado]
#
#		# Crear la stamp
#		var s = stamp.instance()
#		s.name = nombre_seleccionado
#		s.get_node("Sprite").region_rect.position = data["position"]
#		s.get_node("Sprite").region_rect.size = data["size"]
#		s.global_position = Vector2(0, 0)
#
#		s.set_meta("base_pos", s.get_node("Sprite").position)
#
#		# Configurar labels
#		var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
#		var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
#		var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
#
#		for label in [titulo_label, desc_label, costo_label]:
#			label.bbcode_enabled = true
#
#		titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
#		desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
#		costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["plata"])) + "[color=#b1911a]" + Global.prefix_plata
#
#		add_child(s)
#
#		# Eliminar del mazo_actual y refrescar keys
#		mazo_actual.erase(nombre_seleccionado)
#		#mazo_original.erase(nombre_seleccionado)
#		keys = mazo_actual.keys()


func draw_stamps(n, requeridos := []):
	var current_stamps = get_children().size()
	if current_stamps >= Global.stats.max_cards_in_hand:
		return
	
	var keys = mazo_actual.keys()
	if keys.size() == 0:
		return
	
	if n > keys.size():
		n = keys.size()
	
	if current_stamps + n > 8:
		n = 8 - current_stamps
	
	# lista donde vamos a meter primero las requeridas
	var orden_final = []
	
	# ----- 1) agregar las stamps requeridas -----
	for r in requeridos:
		if r in keys:
			orden_final.append(r)
		else:
			print("ERROR: stamp requerida no existe en el mazo:", r)
	
	# si piden mas stamps de las permitidas, recortamos
	if orden_final.size() > n:
		orden_final = orden_final.slice(0, n)
	
	# ----- 2) rellenar con random hasta n -----
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	
	while orden_final.size() < n:
		var nombre = keys[rng.randi() % keys.size()]
		if nombre in orden_final:
			continue
		orden_final.append(nombre)
	
	var count = 0
	
	# ----- 3) Instanciar las stamps en orden_final -----
	for nombre_seleccionado in orden_final:
		count += 1
		var data = mazo_actual[nombre_seleccionado]
		
		var s = stamp.instance()
		s.name = nombre_seleccionado
		
		s.get_node("Sprite").region_rect.position = data["position"]
		s.get_node("Sprite").region_rect.size = data["size"]
		s.global_position = Vector2(0, 0)
		s.set_meta("base_pos", s.get_node("Sprite").position)
		
		var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
		var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
		var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
		
		for label in [titulo_label, desc_label, costo_label]:
			label.bbcode_enabled = true
		
		titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
		desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
		costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["plata"])) + "[color=#b1911a]" + Global.prefix_plata
		
		add_child(s)
		
		# borrar del mazo
		mazo_actual.erase(nombre_seleccionado)
		keys = mazo_actual.keys()
	
	if count > 1:
		Global.reproducir_sonido("card_fan",  get_tree().get_nodes_in_group("camera")[0].global_position)
	elif count != 0:
		Global.reproducir_sonido("card_fan1", get_tree().get_nodes_in_group("camera")[0].global_position)


onready var player = get_tree().current_scene.get_node("wind")
var dragging_anterior = false

func _input(event):
	if dragging != dragging_anterior:
		if dragging:
			Global.reproducir_suave(player)
		else:
			Global.detener_suave(player)
	
	dragging_anterior = dragging
	
	# verificar que sea movimiento de mouse
	if event is InputEventMouseMotion:
		# si estamos arrastrando y el sonido esta activo
		if dragging and player.playing:
			# velocidad real del mouse usando event.relative
			var speed1 = event.relative.length()
			#print(speed1)
			# convertir velocidad a volumen
			player.volume_db = Global.velocidad_a_volumen(speed1)
	
#	if dragging:
#		if get_tree().root.get_node("Game").estacion_actual != "tienda":
#			dragging.free()
#			dragging = null
	
	if get_parent().get_parent().estacion_actual == "tienda" and get_parent().get_parent().baraja_activa == "usando_amuleto":
		if event is InputEventMouseButton:
			# Click izquierdo
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					for s in get_children():
						if s != arrastrado:
							# Verificamos si el mouse está dentro del "círculo" del sprite
							if s.mouse_dentro_area():
								dragging = s
								dragging.get_node("Sprite").z_as_relative = true
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
						
						dragging.get_node("Sprite").z_as_relative = true
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


func _physics_process(_delta):
		if dragging and get_parent().get_parent().estacion_actual != "tienda":
			dragging.free()
			dragging = null
		
		mover_cartas()
		
		if get_parent().get_parent().estacion_actual == "tienda" and get_parent().get_parent().baraja_activa == "usando_amuleto":
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
				
				if hovered_card and hovered_card != arrastrado:
					if not hovered_card.get_meta("moviendo", false):
						hovered_card.start_animation()
			
			last_hovered_card = hovered_card
			
			if dragging:
#				if get_tree().root.get_node("Game").estacion_actual != "tienda":
#					dragging.free()
#					dragging = null
				
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

			var count = stamps_in_play.size()
			if dragging != null or arrastrado != null:
				count += 1  # espacio extra para slot arrastrado

			if count > 0:
				var top_margin = -layout_width/2
				var bottom_margin = layout_width/2
				var step = (bottom_margin - top_margin) / count
				var start_x = top_margin + step / 2
				
				var slot_i = 0
				for i in range(count):
					# Slot reservado para dragging
					if dragging != null and i == closest_slot_index():
						target_pos[dragging] = Vector2(start_x + step * i, 0)
						continue
					
					# Tomamos el stamp correspondiente
					if slot_i >= stamps_in_play.size():
						break  # evita index fuera de rango
					var s = stamps_in_play[slot_i]
					var objetivo = Vector2(start_x + step * i, 0)
					target_pos[s] = objetivo
					slot_i += 1
				
				# Aplicar suavizado
				for s in stamps_in_play:
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
	var mouse_y = get_global_mouse_position().x  # antes era X
	
	var filtered = []
	for d in dominos:
		if d != dragging and d.get_node("Sprite").visible:
			filtered.append(d)
	
	var count = filtered.size() + 1
	var slots = []
	
	for i in range(count):
		if i == 0:
			if filtered.size() > 0:
				var sprite = filtered[0].get_node("Sprite")
				var alto = sprite.region_rect.size.y if sprite.region_enabled else sprite.texture.get_size().y
				slots.append(filtered[0].global_position.x - alto)
			else:
				slots.append(0)
		elif i == count - 1:
			var sprite = filtered[-1].get_node("Sprite")
			var alto = sprite.region_rect.size.y if sprite.region_enabled else sprite.texture.get_size().y
			slots.append(filtered[-1].global_position.x + alto)
		else:
			var prev = filtered[i - 1]
			var next = filtered[i]
			var mid = (prev.global_position.x + next.global_position.x) / 2
			slots.append(mid)
	
	# Buscar el slot más cercano
	var closest = 0
	var min_dist = INF
	for i in range(slots.size()):
		var dist = abs(mouse_y - slots[i])
		if dist < min_dist:
			min_dist = dist
			closest = i
	
	return closest


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
