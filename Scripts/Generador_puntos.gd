extends Node


var generando_moviendo = false
var puntos_en_movimiento = 0

var punto = preload("res://Scenas/punto.tscn")

var p_inicial = {}


var mostrar_part = true

var maximo_puntos_ficticios = 20
var maximo_puntos = 20


# Para guardar el progreso t de cada punto
var progreso = {}


func generar_puntos(cantidad, posicion_inicial, ultima = false):
	mostrar_part = ultima
	
	generando_moviendo = true
	
	for _i in range(cantidad):
		spawn(posicion_inicial, _i)
		
		if puntos_en_movimiento < maximo_puntos_ficticios:
			puntos_en_movimiento += 1
		
		if _i == maximo_puntos:
			break
	
	while puntos_en_movimiento != 0:
		yield(get_tree(), "idle_frame")
	
	generando_moviendo = false


func spawn(pos, i):
	var punto_ins = punto.instance()
	
	punto_ins.visible = false
	
	get_tree().root.get_node("Game/punto").add_child(punto_ins)
	
	punto_ins.global_position = pos
	
	p_inicial[punto_ins] = pos
	
	# Cada punto empieza con t=0
	progreso[punto_ins] = float(-i)


func _physics_process(delta):
	if puntos_en_movimiento == 0:
		return
	
	var destinos = [
	Vector2(-200, 90.5),
	Vector2(-155, 20.5)
	]
	
	var contenedor = get_tree().root.get_node("Game/punto")
	
	for p in contenedor.get_children():
		if progreso[p] < 0.0:
			progreso[p] += 0.1
			continue
		
		p.visible = true
		
		var t = progreso[p]
		
		var velocidad_base = 0.9
		var velocidad_final = velocidad_base + (puntos_en_movimiento * 0.5)
		t += delta * velocidad_final
		
		progreso[p] = t
		
		var nodo_anim = get_tree().root.get_node("Game/Particula_numero")
		print(nodo_anim.ejecutandose)
		
		if t >= 0.4:
			if mostrar_part and !nodo_anim.ejecutandose:
				nodo_anim.global_position = Vector2(-155.856995, 2)
				
				nodo_anim.mostrar_tipo("mult", Global.stats.global_mult, 6.0, [20, 50, 40], 0.2)
				
				nodo_anim.get_parent().shake_reroll()
				
				mostrar_part = false
			
			p.animation = "default1"
		
		# FADE-IN (0.0 a 0.1)
		if t < 0.1:
			var f = t / 0.1
			p.modulate.a = clamp(f, 0.0, 1.0)
		
		# FADE-OUT (0.9 a 1.0)
		elif t > 0.9:
			var f = (1.0 - t) / 0.1
			p.modulate.a = clamp(f, 0.0, 1.0)
		
		# Normal
		else:
			p.modulate.a = 1.0
		
		
		var t_ease = t * t * (3 - 2 * t)
		
		var p1 = destinos[0]
		var p2 = destinos[1]
		var p3 = destinos[1] + (destinos[1] - destinos[0]) * 0.5    # drift
		
		var pos = cubic_bezier(
			p_inicial[p],   # necesitas guardar "p_inicial" al spawnear
			p1, p2, p3,
			t_ease
		)
		
		
		if t >= 1.0:
			# cuando llega al final, eliminar
			p.queue_free()
			progreso.erase(p)
			
			if contenedor.get_child_count() <= maximo_puntos_ficticios:
				puntos_en_movimiento -= 1
			
			continue
		
		p.global_position = pos


# -------------------------------------
# FUNCION DE BEZIER (no se toca)
# -------------------------------------
func cubic_bezier(p0, p1, p2, p3, t):
	var u = 1.0 - t
	var tt = t * t
	var uu = u * u
	var uuu = uu * u
	var ttt = tt * t

	return uuu * p0 + 3 * uu * t * p1 + 3 * u * tt * p2 + ttt * p3
