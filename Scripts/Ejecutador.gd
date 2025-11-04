extends Node




func ejecutar_jugada(nodo):
	print("______________________________________________________")
	recorrer_domino(nodo, 1.0, 0, 1.0, 0) # mult_global, puntaje_extra, mult_padre, puntos_acumulados


func recorrer_domino(d: Node, mult_global: float, puntaje_extra: int, mult_padre: float, puntos_acumulados: float) -> void:
	var yo = d.yo
	
	var mult_total = yo.mult_actual * mult_padre
	var puntaje_total = yo.puntaje * mult_total + puntaje_extra
	var mult_global_nuevo = mult_global + (yo.mult_global - 1) # si es 1, suma 0 real
	var puntos_acumulados_nuevos = puntos_acumulados + puntaje_total
	
	print("------------------------------------------")
	print("Domino:", yo.titulo)
	print("  Puntaje base:", yo.puntaje)
	print("  mult_actual:", yo.mult_actual)
	print("  mult_global:", yo.mult_global, " (efecto real:", yo.mult_global - 1, ")")
	print("  mult_siguiente:", yo.mult_siguiente)
	print("  puntaje_siguiente:", yo.puntaje_siguiente)
	print("  mult_total aplicado:", mult_total)
	print("  puntaje total mostrado:", puntaje_total)
	print("  mult_global acumulado:", mult_global_nuevo)
	print("  Puntos acumulados hasta ahora:", puntos_acumulados_nuevos)
	print("  global_position:", d.global_position)
	
	for slot in d.get_slots_in_self():
		if slot.hijo != null:
			recorrer_domino(
				slot.hijo,
				mult_global_nuevo,
				puntaje_extra + yo.puntaje_siguiente,
				mult_total * yo.mult_siguiente,
				puntos_acumulados_nuevos
			)
