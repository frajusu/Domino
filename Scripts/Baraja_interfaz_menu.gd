extends YSort



var domino = preload("res://Scenas/Domino_interfaz.tscn")

var mazo_original
var mazo_actual

var letters = []

var mover_cartas1 = true

var dragging = null
var arrastrado = null
var offset = Vector2(0,0)
var target_pos = {}
var return_to_pos = false  # indica que debe volver suavemente

export var color_a_invocar = ""

var mouse_over = false  # variable que indica si el mouse está encima


func _ready():
	#draw_cards(8)
	mazo_original = Global.dominos.duplicate()
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

var layout_width = 470     # ancho máximo del layout
var spacing = 10           # separación mínima
var velocidad_layout = 20  # suavizado



func draw_cards(color: String) -> void:
	mazo_actual = get_parent().get_parent().get_node("Baraja").mazo_original.duplicate()
	
	# Obtener claves ordenadas
	var keys = Global.ordenar_dominos_por_color_y_numero(mazo_actual)
	
	if keys.size() == 0:
		print("No quedan cartas en el mazo")
		return
	
	# Filtrar solo las cartas del color pedido
	var cartas_color := []
	for nombre in keys:
		if nombre.begins_with(color + "_"):
			cartas_color.append(nombre)
	
	if cartas_color.size() == 0:
		print("No hay cartas del color ", color, " en el mazo")
		return
	
	# Crear todas las cartas del color elegido en el orden correcto
	for nombre in cartas_color:
		var _datos = mazo_actual[nombre]
		
		var s = domino.instance()
		s.set_meta("base_pos", s.get_node("Sprite").position)
		s.nombre = nombre
		add_child(s)
		s.global_position = Vector2(0, 750)
		
		if get_parent().get_parent().get_node("Baraja").mazo_actual.has(nombre):
			s.existente = true
		else:
			s.existente = false



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
