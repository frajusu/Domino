extends YSort



var domino = preload("res://Scenas/Domino.tscn")

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
	#draw_cards(8)
	if !Global.continuar:
		mazo_original = Global.dominos.duplicate()
		mazo_actual = mazo_original.duplicate()
	
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


func contar_dominos_por_color(color: String) -> int:
	var contador = 0
	
	for nombre in mazo_original.keys():
		# ejemplo: "rojo_1", "azul_3", etc.
		if nombre.begins_with(color + "_"):
			contador += 1
	
	return contador


func draw_cards(n, anashe = false):
	if get_parent().get_parent().draws_actuales > 0 or anashe:
		var current_cards = get_children().size()
		
		if current_cards >= Global.stats.max_cards_in_hand:
			print("Ya tienes ",Global.stats.max_cards_in_hand," cartas en juego, no se pueden agregar mas")
			return
		
		var keys = mazo_actual.keys()
		
		if keys.size() == 0:
			print("No quedan cartas en el mazo")
			return
		
		if n > keys.size():
			print("No vas a poder sacar mas, solo quedan %d cartas" % keys.size())
			n = keys.size()
		
		var count = 0
		
		if keys.size() != mazo_original.keys().size() and !anashe:
			get_parent().get_parent().draws_actuales -= 1
		
		get_parent().get_parent().get_node("Viewport/1/1/Draws/Draws_num/Draws_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(get_parent().get_parent().draws_actuales)+"\n[/wave]"
		
		# limitar n para que no se pase del maximo de 8
		if current_cards + n > Global.stats.max_cards_in_hand:
			#print("Solo se pueden agregar %d cartas para no pasar de 8" % (8 - current_cards))
			n = Global.stats.max_cards_in_hand - current_cards
		
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		
		for _i in range(n):
			count += 1
			# si ya no quedan cartas, salimos
			if keys.size() == 0:
				break
			
			# 1) Elegir color usando tu funcion (no recibe args)
			var color_elegido = elegir_color()  # devuelve algo como "rose", "orange", "green", "blue"
			
			# 2) Normalizar/mapeo para coincidir con mazo_actual[..].color ("Pink","Orange","Blue","Green")
			var desired_color := ""
			
			desired_color = color_elegido.capitalize()  # "orange" -> "Orange", "green" -> "Green", "blue" -> "Blue"
			
			# 3) Crear lista filtrada por color
			var keys_filtradas = []
			for k in keys:
				# mazo_actual[k].color suele ser "Orange","Pink","Blue","Green"
				if str(mazo_actual[k].color).to_lower() == desired_color.to_lower():
					keys_filtradas.append(k)
			
			# 4) Si no hay dominos de ese color, usar todos los keys disponibles
			if keys_filtradas.size() == 0:
				keys_filtradas = keys
			
			# 5) Elegir uno random de los filtrados
			var index = rng.randi_range(0, keys_filtradas.size() - 1)
			var nombre = keys_filtradas[index]
			var _datos = mazo_actual[nombre]
			
			# 6) Crear carta
			var s = domino.instance()
			s.set_meta("base_pos", s.get_node("Sprite").position)
			s.nombre = Global.quitar_t_extra(nombre)
			s.get_node("Sprite").visible = true
			s.yo = mazo_actual[nombre]
			add_child(s)
			s.global_position = Vector2(70, 170)
			
			# 7) Borrar del mazo y actualizar keys para la siguiente iteracion
			mazo_actual.erase(nombre)
			keys = mazo_actual.keys()
		
		if count > 1:
			Global.reproducir_sonido("card_fan",  get_tree().get_nodes_in_group("camera")[0].global_position)
		elif count != 0:
			Global.reproducir_sonido("card_fan1", get_tree().get_nodes_in_group("camera")[0].global_position)
		
		print("Cartas restantes: ", keys.size())
	else:
		get_parent().get_parent().get_node("Viewport/1/1/Draws/AnimationPlayer").play("mover")
		print("No tenes draws")


func elegir_color(stats = Global.stats) -> String:
	var stats_especificas = {
		"rose_%" :   stats["rose_%"],
		"orange_%" : stats["orange_%"],
		"green_%" :  stats["green_%"],
		"blue_%" :   stats["blue_%"],
	}
	
	stats_especificas["rose_%"]   = revisar_resurgence("Rose Resurgence",   stats_especificas["rose_%"])
	stats_especificas["orange_%"] = revisar_resurgence("Orange Resurgence", stats_especificas["orange_%"])
	stats_especificas["green_%"]  = revisar_resurgence("Blue Resurgence",   stats_especificas["green_%"])
	stats_especificas["blue_%"]   = revisar_resurgence("Green Resurgence",  stats_especificas["blue_%"])
	
	var total := 0.0
	for v in stats_especificas.values():
		total += v
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var r = rng.randf() * total
	
	for key in stats_especificas.keys():
		r -= stats_especificas[key]
		if r <= 0:
			#print(key.replace("_%", ""))
			return key.replace("_%", "")  # "rose_%"" -> "rose"
	
	#print(stats_especificas.keys()[0].replace("_%", ""))
	
	return stats_especificas.keys()[0].replace("_%", "")


func revisar_resurgence(amuleto, stat):
	if get_parent().get_parent().amuletos_tenidos.has(amuleto):
		var colores = {
			"rose" : 0,
			"orange" : 0,
			"blue" : 0,
			"green" : 0,
		}
		
		var mazo = get_tree().root.get_node("Game/Viewport/Baraja").mazo_original
		
		for i in mazo.keys():
			var color = mazo[i].color.to_lower()
			if colores.has(color):
				colores[color] += 1
		
		var cantidad_rose = colores["rose"]
		
		# -----------------------------
		# AJUSTE DE CHANCE (CORRECTO)
		# -----------------------------
		var referencia := 10.0 # ajusta segun tu juego
		var factor := referencia / float(cantidad_rose + 1)
		
		stat *= factor
	
	return stat


func _physics_process(_delta):
		get_parent().get_node("Zona_de_baraja/Cartas_Actuales").text = str(get_child_count())
		get_parent().get_node("Zona_de_baraja/Cartas_Max").text = str(Global.stats.max_cards_in_hand)
		get_parent().get_node("Zona_de_botones/Cartas_Actuales").text = str(mazo_actual.keys().size())
		get_parent().get_node("Zona_de_botones/Cartas_Max").text = str(mazo_original.keys().size())
		
		mover_cartas()
		
		var hovered_card = null
		
		for s in get_children():
#			if s.scale_puede_cambiar:
#				if dragging != s:
#					s.scale = Vector2(1,1)
#				else:
#					s.scale = Vector2(1.1,1.1)
			
			s.get_node("Sprite-top").visible = !s.get_node("Sprite").visible
			if s.mouse_dentro_area():
				hovered_card = s
				break
		
		if get_parent().get_parent().baraja_activa == "baraja":
			if hovered_card != last_hovered_card and !dragging:
				#if last_hovered_card and is_instance_valid(last_hovered_card):
				#	last_hovered_card.get_node("Sprite-top").material.set_shader_param('outline_size', 0)
				
				if hovered_card and hovered_card != arrastrado:
					if not hovered_card.get_meta("moviendo", false):
						hovered_card.start_animation()
			
			
			last_hovered_card = hovered_card
		
		if dragging:
#			if get_tree().root.get_node("Game").estacion_actual != "nivel":
#				dragging.free()
#				dragging = null
			
			var sprite = dragging
			if sprite.get_node("Sprite").visible or true:
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
			
			player.volume_db -= 7
			
			if speed1 < 5:
				player.volume_db = -80
	
#	if dragging:
#		if get_tree().root.get_node("Game").estacion_actual != "nivel":
#			dragging.free()
#			dragging = null
	
	if (get_parent().get_parent().baraja_activa == "baraja" or (get_parent().get_parent().baraja_activa == "baraja_especial" and is_over_drop_zone())) and !Ejecutador.ejecutando:
		if event is InputEventMouseButton:
			# Click izquierdo
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					for s in get_children():
						if s != arrastrado:
							if (get_parent().get_parent().baraja_activa != "baraja" and !s.get_node("Sprite").visible) or (get_parent().get_parent().baraja_activa == "baraja"):
								# Verificamos si el mouse está dentro del "círculo" del sprite
								if s.mouse_dentro_area() and !get_parent().get_node("Zona_de_specials/Baraja_S").dragging:
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
							
							dragging.desaparecer()
						else:
							if dragging.padre == null:
								dragging.get_node("Sprite").visible = true
								dragging.get_node("Sprite-top").visible = false
								
								dragging.desaparecer()
						
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
								s.desaparecer()
								
								s.get_node("Sprite").visible = true
								s.get_node("Sprite-top").visible = false
		
		elif event is InputEventMouseMotion and dragging:
			# --- Movimiento principal ---
			dragging.get_node("Sprite").visible = !is_over_drop_zone()
			
			var imprimir = false
			
			if imprimir:
				var _padre_nombre = "null"
				if dragging.padre != null:
					if (typeof(dragging.padre) != TYPE_INT):
						_padre_nombre = dragging.padre.nombre
					else: _padre_nombre = dragging.padre
				
				var _hijo_nombre = []
				
				for i in dragging.get_slots_in_self():
					if i.hijo != null:
						_hijo_nombre.append(i.hijo.nombre)
				
				print("Padre: ", _padre_nombre, ", Hijo: ", _hijo_nombre)
			
			if Global.usar_offset:
				if dragging.get_node("Sprite").visible:
					dragging.global_position = get_global_mouse_position() + offset
				else:
					dragging.global_position = get_global_mouse_position()
			else:
				if dragging.get_node("Sprite").visible:
					dragging.global_position = get_global_mouse_position()
				else:
					dragging.global_position = get_global_mouse_position()
			
			if dragging.get_node("Sprite").visible == false:
				
				var nodos = []
				
				for i in dragging.get_slots_in_self():
					nodos += get_all_descendants(i.hijo)
				
				if nodos.size() != 0:
					for actual in nodos:
						if !actual.objeto_over_area(get_tree().root.get_node("Game/Viewport/GameArea/Area2D"), 1):
							actual.desaparecer()
			
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
		
		elif event is InputEventMouseMotion and !get_parent().get_node("Zona_de_specials/Baraja_S").dragging:
			var slots = get_tree().get_nodes_in_group("slots")
			
			for s in slots:
				if s.hijo == null and s.get_parent().get_parent().get_node("Sprite").visible == false:
					s.visible = false


func get_all_descendants(node: Node) -> Array:
	#print(node)
	var result = []
	if node != null:
		result = [node]  # agregamos el nodo actual
		for child in node.get_slots_in_self():
			result += get_all_descendants(child.hijo)  # agregamos recursivamente los descendientes
	
	return result


func contar_activos():
	var count = 0
	
	for i in get_parent().get_node("Zona_de_specials/Baraja_S").get_children()+get_children():
		if !i.get_node("Sprite").visible and i != dragging:
			count += 1
	
	return count


var lock_distance := 20  # distancia para lockear


func aplicar_repulsion_global():
	if true:
		if dragging:
			if dragging.get_node("Sprite").visible == false and contar_activos() < Global.stats.dominos_on_gamezone:
				var slots = get_tree().get_nodes_in_group("slots")
				
				for s in slots:
					var domino_slot = s.get_parent().get_parent()
					
					if dragging.yo.padre != 2:
						if !domino_slot.esta_en_cadena(dragging):
							if s.hijo == null and domino_slot.get_node("Sprite").visible == false and domino_slot != dragging and (dragging.yo.padre == 1 or dragging.yo.padre == 0):
								s.visible = true
				
				for i in dragging.get_slots_in_self():
					if i.hijo != null:
						i.visible = true
					else:
						i.visible = false
				
				if true:
					for s in slots:
						if !dragging.get_slots_in_self().has(s):
							if dragging.yo.padre != 2 and dragging.yo.padre != 3:
								var domino_slot = s.get_parent().get_parent()
								
								var dist = dragging.global_position.distance_to(s.global_position)
								
								if dist < lock_distance:
									if s.hijo == null or s.hijo == dragging:
										dragging.global_position = s.global_position
									
									if s.hijo == null:
										var raiz = dragging.obtener_raiz()
										if !domino_slot.esta_en_cadena(raiz):
											s.hijo = dragging
											dragging.padre = domino_slot
											continue
								else:
									if s.hijo == dragging:
										s.hijo = null
										dragging.padre = null
							
							if dragging.yo.padre != 1:
								var primero := true
								
								for d in get_tree().get_nodes_in_group("dominos"):
									if d != dragging and !d.get_node("Sprite").visible and d.yo.padre != 3:
										primero = false
										break
								
								if (dragging.padre != null):
									primero = false
								
								if primero or (typeof(dragging.padre) == TYPE_INT and dragging.padre == 1):
									if dragging.get_parent().name == "Baraja_S":
										#print("HJKASDHJKAWSD")
										dragging.posision_fija = dragging.global_position
									
									dragging.padre = 1
								
								if dragging.yo.padre == 3:
									dragging.padre = 2
									
									if dragging.get_parent().name == "Baraja_S":
										dragging.posision_fija = dragging.global_position
			else:
				var slots = get_tree().get_nodes_in_group("slots")
				
				for s in slots:
					if s.hijo == null and s.get_parent().get_parent().get_node("Sprite").visible == false:
						s.visible = false
				
				if contar_activos() == Global.stats.dominos_on_gamezone:
					get_tree().root.get_node("Game/Viewport/GameArea/Texto_limite/Animation_texto").play("mover")


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
