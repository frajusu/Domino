extends Node




func ejecutar_jugada(nodo):
	print("______________________________________________________")
	print(recorrer_domino(nodo, 1.0, 0, 1.0, 0, 0, [], false))


func recorrer_domino(d: Node, mult_global: float, puntaje_extra: int, mult_padre: float, puntos_acumulados: float, indice: int, visitados: Array, en_reversa: bool, comentario = ""):
	if d in visitados and !en_reversa:
		return 0 # evita bucles infinitos
	visitados.append(d)
	
	var yo = d.yo
	var mult_total = yo.mult_actual * mult_padre
	var puntaje_total = yo.puntaje * mult_total + puntaje_extra
	var mult_global_nuevo = mult_global + (yo.mult_global - 1)
	var puntos_acumulados_nuevos = puntos_acumulados
	var info_extra = ""
	
	var puntajes_a_devolver = puntaje_total
	
	# === EFECTOS (flags) ===
	var efecto_specific100 = false
	var efecto_mult3x = false
	var efecto_2xbehind = false
	var efecto_reverse = false
	var efecto_mirror = false
	var efecto_ruler = false
	var efecto_banana = false
	
	
	# === MATCH: activa flags y fija info_extra ===
	match yo.titulo:
		"Specific <#296e8f>100":
			efecto_specific100 = true
			info_extra = "(anade +100 si es 2do y ultimo)"
		"<#e0483e>Multiplier <#e0483e>3x":
			efecto_mult3x = true
			info_extra = "(triplica si es 3ro)"
		"<#e0483e>2x Behind":
			efecto_2xbehind = true
			info_extra = "(duplica lo hecho antes)"
		"<#238c73>Reverse":
			efecto_reverse = true
			info_extra = "(invierte la direccion)"
		"<#76357a>Mirror":
			efecto_mirror = true
			info_extra = "(crea una linea espejo)"
		"<#e19124>Ruler":
			efecto_ruler = true
			info_extra = "(extiende la linea)"
		"<#c9a61f>Banana":
			efecto_banana = true
			info_extra = "(rebota hacia atras y sigue otra ruta)"
		_:
			info_extra = ""
	
	
	puntos_acumulados_nuevos += puntaje_total
	
	
	# === IMPRESION ===
	var direccion_texto = "ADELANTE"
	if en_reversa:
		direccion_texto = "ATRAS"
	
	print("------------------------------------------")
	print("Domino:", yo.titulo, info_extra, "   ", comentario)
	print("  Puntaje base:", yo.puntaje)
	print("  mult_actual:", yo.mult_actual)
	print("  mult_global:", yo.mult_global)
	print("  mult_siguiente:", yo.mult_siguiente)
	print("  puntaje_siguiente:", yo.puntaje_siguiente)
	print("  mult_total aplicado:", mult_total)
	print("  puntaje total mostrado:", puntaje_total)
	print("  mult_global acumulado:", mult_global_nuevo)
	print("  Puntos acumulados hasta ahora:", puntos_acumulados_nuevos)
	print("  Pos:", d.global_position)
	print("  Direccion actual:", direccion_texto)
	
	
	# === EFECTOS ===
	if efecto_specific100:
		if indice == 1 and d.get_slots_in_self().size() == 0:
			puntaje_total += 100
			# info_extra ya fue fijado en el match
		else:
			# si queres indicarlo explicitamente, podes concatenarlo
			info_extra = info_extra + " (sin bonus de 100)"
	
	if efecto_mult3x:
		if indice == 2:
			mult_total *= 3.0
		else:
			info_extra = info_extra + " (sin efecto x3)"
	
	if efecto_2xbehind:
		puntaje_total += puntos_acumulados * 1.0
	
	
	# Banana: rebota al padre y sigue otra rama (ejecuta recursivamente)
	if efecto_banana:
		if d.padre != null and (typeof(d.padre) != TYPE_INT):
			# llamo al padre en modo reverse empezando indice en 1 y visitados vacio para permitir ese recorrido
			puntajes_a_devolver += recorrer_domino(
				d.padre,
				mult_global,
				puntaje_extra,
				mult_padre,
				puntos_acumulados,
				1,
				[],
				true
			)
			# no return: dejamos que el resto del codigo siga si queres tambien procesar hijos normales
	
	
	# 🔄 Reverse: vuelve hacia atras (padre)
	if efecto_reverse and d.padre != null and (typeof(d.padre) != TYPE_INT):
		print("→ Reverse activado: volviendo al padre ", d.padre.yo.titulo)
		puntajes_a_devolver += recorrer_domino(
			d.padre,
			mult_global_nuevo,
			puntaje_extra,
			mult_total,
			puntos_acumulados_nuevos,
			indice + 1,
			visitados,
			true
		)
		return puntajes_a_devolver
	
	
	# 📏 Ruler: genera una linea recta virtual
	if efecto_ruler:
		var direccion = Vector2(60, 0)
		if en_reversa:
			direccion = -direccion
		for i in range(3):
			var pos_virtual = d.global_position + direccion * (i + 1)
			print("→ Ruler crea segmento virtual en ", pos_virtual)
			print("   Puntaje estimado: ", puntaje_total + (i + 1) * 5)
	
	
	# 🪞 Mirror: crea una linea paralela
	if efecto_mirror:
		print("→ Mirror activado: recorriendo linea espejo")
		for slot in d.get_slots_in_self():
			if slot.hijo != null:
				print("   Linea espejo de ", slot.hijo.yo.titulo)
				puntajes_a_devolver += recorrer_domino(
					slot.hijo,
					mult_global_nuevo,
					puntaje_extra + yo.puntaje_siguiente,
					mult_total * yo.mult_siguiente,
					puntos_acumulados_nuevos,
					indice + 1,
					visitados.duplicate(),
					en_reversa,
					"ESPEJADO"
				)
	
	
	if en_reversa:
		if d.padre != null and (typeof(d.padre) != TYPE_INT):
			puntajes_a_devolver += recorrer_domino(
				d.padre,
				mult_global_nuevo,
				puntaje_extra,
				mult_total,
				puntos_acumulados_nuevos,
				indice + 1,
				visitados,
				true
			)
	else:
		# === RECORRIDO NORMAL ===
		for slot in d.get_slots_in_self():
			if slot.hijo != null:
				puntajes_a_devolver += recorrer_domino(
					slot.hijo,
					mult_global_nuevo,
					puntaje_extra + yo.puntaje_siguiente,
					mult_total * yo.mult_siguiente,
					puntos_acumulados_nuevos,
					indice + 1,
					visitados,
					en_reversa,
					comentario
				)
	
	
	return puntajes_a_devolver
