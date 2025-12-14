extends Node2D

var mover_cartas1 = false
var speed = 4.0
var amplitude = 5.0

var cartas = []


func _physics_process(_delta):
	if mover_cartas1:
		mover_cartas()


func mover_cartas():
	# Obtener los 3 nodos hijos del nodo principal
	if cartas.empty():
		for grupo in get_children():        # los 3 nodos principales
			var subcartas = grupo.get_children()   # sus 4 hijos
			for carta in subcartas:
				carta.set_meta("base_pos", carta.position)
				cartas.append(carta)
	
	var time = OS.get_ticks_msec() / 1000.0 * speed
	
	# Mover solo las cartas (no los 3 nodos principales)
	for i in range(cartas.size()):
		var carta = cartas[i]
		var base_pos = carta.get_meta("base_pos")
		
		var phase = i * 0.5
		carta.position.y = base_pos.y + sin(time + phase) * amplitude
