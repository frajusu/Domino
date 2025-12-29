extends Node


var limite_para_cada_domino = 2


var valor_de_shader := 0.0
var secuencia_puntaje := [] # pasos precalculados
var max_puntos_totales := 0
var delay_por_domino := 1.0 # segundos entre animaciones

var valor_animado := 0.0

var ejecutando = false


var repetir_play = false


var hacer_pop_up_grande = false


var convertir_a_plata = false


var print_s = false


var repeticiones_posibles = 0
var repeticiones_posibles_array = []


var primer_domino = null


func ejecutar_jugada(nodo):
	cambiar_i()
	convertir_a_plata = false
	repetir_play = false
	if print_s: print("______________________________________________________")
	secuencia_puntaje.clear()
	delay_por_domino = 1.0
	ejecutando = true
	max_puntos_totales = recorrer_domino(nodo, 1.0, 0, 1.0, 0, 0, [], false)
	if print_s: print("✅ Puntos totales precalculados:", max_puntos_totales)
	# ahora que tenemos la secuencia completa, la reproducimos animada
	reproducir_secuencia()


func recorrer_domino(d: Node, mult_global: float, puntaje_extra: int, mult_padre: float, puntos_acumulados: float, indice: int, visitados: Array, en_reversa: bool, comentario = [], ejecuciones = {}):
	convertir_a_plata = false
	repetir_play = false
	
	if d == null:
		return 0
	
	# --- Control de ejecuciones ---
	var clave = d
	if comentario.has("ESPEJADO"):
		if d.get_parent().name == "Baraja_S":
			return 0
		clave = str(d.get_instance_id()) + "_mirror"
	else:
		clave = str(d.get_instance_id())
	
	if not ejecuciones.has(clave):
		ejecuciones[clave] = 0
	ejecuciones[clave] += 1
	if ejecuciones[clave] > limite_para_cada_domino:
		if print_s: print("⚠ Limite alcanzado para", d.name, "(", comentario, ") — evitando recursion infinita")
		return 0
	
	# --- Control de bucles normales ---
	if d in visitados and !en_reversa:
		return 0
	visitados.append(d)
	
	
	
	if primer_domino == null:
		primer_domino = d
	
	
	
	var yo = d.yo
	var mult_total = float(yo.mult_actual) * float(mult_padre)
	
	var puntaje_total = yo.puntaje * float(mult_total) + puntaje_extra
	
	puntaje_total *= Global.stats[yo.color.to_lower()+"_mult"]
	
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
	var efecto_long_shot = false
	var efecto_eye = false
	
	var efecto_sticky = false
	
	
	# === MATCH: activa flags y fija info_extra ===
	match yo.titulo:
		"Specific <#296e8f>100":
			efecto_specific100 = true
			info_extra = "(anade +100 si es 2do y ultimo)"
		"<#296e8f>Long Shot":
			efecto_long_shot = true
			info_extra = "(anade cantidad despues de el)"
		"<#38b338>Sticky":
			efecto_sticky = true
			info_extra = "(anade 1 permanente)"
		"<#e0483e>Eye":
			efecto_eye = true
			info_extra = "(anade maximo)"
		"<#e0483e>Multiplier <#e0483e>2x":
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
	
	var plata_que_da = 0
	
	var puntaje_propio = puntaje_total
	
	# === IMPRESION ===
	var direccion_texto = "ADELANTE"
	if en_reversa:
		direccion_texto = "ATRAS"
	
	
	var texto = "\n------------------------------------------\n"
	texto += "Domino: %s %s   %s\n" % [d.nombre, info_extra, comentario]
	texto += "  Puntaje base: %s\n" % yo.puntaje
	#texto += "  mult_actual: %s\n" % yo.mult_actual
	#texto += "  mult_global: %s\n" % yo.mult_global
	#texto += "  mult_siguiente: %s\n" % yo.mult_siguiente
	#texto += "  puntaje_siguiente: %s\n" % yo.puntaje_siguiente
	#texto += "  mult_total aplicado: %s\n" % mult_total
	#texto += "  puntaje total mostrado: %s\n" % puntaje_total
	#texto += "  mult_global acumulado: %s\n" % mult_global_nuevo
	texto += "  Puntos acumulados hasta ahora: %s\n" % puntos_acumulados_nuevos
	if comentario.has("ESPEJADO"):
		texto += "  Pos: %s\n" % str(d.global_position + Vector2(0, 50))
	else:
		texto += "  Pos: %s\n" % str(d.global_position)
	texto += "  Direccion actual: %s\n" % direccion_texto
	if print_s: print(texto)
	
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
			mult_total *= 2.0
		else:
			info_extra = info_extra + " (sin efecto x3)"
	
	
	if efecto_2xbehind:
		puntaje_total += puntos_acumulados * 2.0
	
	
	if comentario.has("STICKY"):
		var baraja = d.get_parent()
		var puntaje = baraja.mazo_original[d.nombre].puntaje
		
		baraja.mazo_original[d.nombre].puntaje = puntaje+1
		d.yo.puntaje = puntaje+1
	
	if efecto_sticky:
		comentario+=["STICKY"]
	
	
	if efecto_long_shot:
		puntaje_total += d.get_parent().get_all_descendants(d).size()-1
	
	
	if efecto_eye:
		var puntaje_a_dar = 0
		
		for paso in secuencia_puntaje:
			var puntos_propios = paso["puntaje_propio"]
			
			if puntaje_a_dar < puntos_propios:
				puntaje_a_dar = puntos_propios
		
		puntaje_total += puntaje_a_dar
	
	
	# Ruler: genera una linea recta virtual
	if efecto_ruler:
		var hijos = d.get_parent().get_all_descendants(d)
		
		var ultimo_hijo = hijos[hijos.size()-1]
		
		var suma = (abs(primer_domino.global_position.x-ultimo_hijo.global_position.x))/10.0
		
		if print_s: print(suma)
		
		puntaje_total += suma
	
	puntaje_propio = puntaje_total
	
	if comentario.has("ESPEJADO"):
		puntaje_propio *= 1.5
		
		secuencia_puntaje.append({
			"domino": d,
			"posicion": d.global_position + Vector2(0, 50),
			"puntaje_propio": int(puntaje_propio),
			"puntaje_max": int(puntaje_propio),
			"array_especiales" : [],
			"array_especiales_amuletos" : [],
			"mult": mult_total,
			"mult_color": 0.0,
			"plata": plata_que_da* Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"],
			"puntos_acumulados": puntos_acumulados_nuevos
		})
	else:
		secuencia_puntaje.append({
			"domino": d,
			"posicion": d.global_position,
			"puntaje_propio": int(puntaje_propio),
			"puntaje_max": int(puntaje_propio),
			"array_especiales" : [],
			"array_especiales_amuletos" : [],
			"mult": mult_total,
			"mult_color": 0.0,
			"plata": plata_que_da*  Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"],
			"puntos_acumulados": puntos_acumulados_nuevos
		})
	
	
	var array_especial = revisar_stamps(d)
	
	
	for i in array_especial:
		if i[1] == "especial_suma":
			secuencia_puntaje[secuencia_puntaje.size()-1].puntaje_max += (i[0])
		
		if i[1] == "suma":
			secuencia_puntaje[secuencia_puntaje.size()-1].puntaje_max += (i[0])
	
	
	secuencia_puntaje[secuencia_puntaje.size()-1].array_especiales = array_especial
	
	
	
	
	secuencia_puntaje[secuencia_puntaje.size()-1].mult_color = Global.stats[d.yo.color.to_lower()+"_mult"]
	
	
	
	
	
	var array_especial_amuletos = revisar_amuletos_por_domino(d)
	
	
	for i in array_especial_amuletos:
		if i[1] == "especial_suma":
			secuencia_puntaje[secuencia_puntaje.size()-1].puntaje_max += (i[0])
		
		if i[1] == "suma":
			secuencia_puntaje[secuencia_puntaje.size()-1].puntaje_max += (i[0])
	
	
	secuencia_puntaje[secuencia_puntaje.size()-1].array_especiales_amuletos = array_especial_amuletos
	
	
	
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
				true, comentario,
				ejecuciones
			)
			# no return: dejamos que el resto del codigo siga si queres tambien procesar hijos normales
	
	
	# Reverse: vuelve hacia atras (padre)
	if efecto_reverse and d.padre != null and (typeof(d.padre) != TYPE_INT):
		if print_s: print("→ Reverse activado: volviendo al padre ", d.padre.yo.titulo)
		puntajes_a_devolver += recorrer_domino(
			d.padre,
			mult_global_nuevo,
			puntaje_extra,
			mult_total,
			puntos_acumulados_nuevos,
			indice + 1,
			visitados,
			true, "",
			ejecuciones
		)
		return puntajes_a_devolver
	
	
	# Mirror: crea una linea paralela
	if efecto_mirror:
		if print_s: print("→ Mirror activado: recorriendo linea espejo")
		for slot in d.get_slots_in_self():
			if slot.hijo != null:
				if print_s: print("   Linea espejo de ", slot.hijo.yo.titulo)
				puntajes_a_devolver += recorrer_domino(
					slot.hijo,
					mult_global_nuevo,
					puntaje_extra + yo.puntaje_siguiente,
					mult_total * yo.mult_siguiente,
					puntos_acumulados_nuevos,
					indice + 1,
					visitados.duplicate(),
					en_reversa,
					comentario+["ESPEJADO"],
					ejecuciones
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
				true, "",
				ejecuciones
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
					comentario,
					ejecuciones
				)
	
	d.get_parent().mazo_original[d.nombre].usado += 1
	
	if print_s: print(d.nombre, "   ", d.get_parent().mazo_original[d.nombre].usado)
	
	return int(puntajes_a_devolver)


func reproducir_secuencia():
	if secuencia_puntaje.size() == 0:
		return
	
	_call_next_step(0)


var valor_actual := 0.0
var puntos_shader_max := 10.0
var barras


func _ready():
	if get_tree().root.has_node("Game"):
		barras = get_tree().root.get_node("Game/Barras/barras")


var max_progress = 0.5


func _physics_process(delta):
	if get_tree().root.has_node("Game"):
		barras = get_tree().root.get_node("Game/Barras/barras")
		puntos_shader_max = barras.get_parent().get_parent().puntos_por_nivel(barras.get_parent().get_parent().nivel_actual)*4
		var target = clamp(valor_actual, 0.0, max_progress)
		#print(puntos_shader_max, "     ", valor_animado, "    ", target)
		barras.material.set_shader_param("progress1", lerp(barras.material.get_shader_param("progress1"), target, delta * 8))


var nodo_anim
var ultimo = null



func _call_next_step(i):
	nodo_anim = get_tree().root.get_node("Game/Particula_numero")
	
	if i >= secuencia_puntaje.size():
		primer_domino = null
		
		if print_s: print("Secuencia completada")
		
		if print_s: print(get_tree().root.get_node("Game").EFECTOS_TEMPORALES)
		
		for i in get_tree().root.get_node("Game").EFECTOS_TEMPORALES.duplicate():
			var operador = str(i[0])[0]
			var valor = float(str(i[0]).substr(1))
			var stat = i[1]
			
			if i[2] != 0:
				# aplicar
				if i[3]:
					match operador:
						"x":
							Global.stats[stat] *= valor
						"+":
							Global.stats[stat] += valor
						"-":
							Global.stats[stat] -= valor
					
					i[3] = false
				
				i[2] -= 1
			else:
				get_tree().root.get_node("Game").EFECTOS_TEMPORALES.erase(i)
				get_tree().root.get_node("Game").recalcular_stat(stat)
		
		if print_s: print(get_tree().root.get_node("Game").EFECTOS_TEMPORALES)
		
		if hacer_pop_up_grande:
			nodo_anim.scale = Vector2(0.5, 0.5)
			nodo_anim.mostrar_tipo("suma", valor_animado, 2.0, [20, 50, 40], 0.4)
			
			yield(get_tree().create_timer(1), "timeout") 
		
		
		
		
		if repeticiones_posibles != 0:
			i = i-3
			
			if i < 0:
				i = 0
			
			Global.usar_amuleto_animacion(repeticiones_posibles_array[repeticiones_posibles-1])
			repeticiones_posibles_array.remove(repeticiones_posibles-1)
			
			#codigo ejecutando cosas del array
			
			while !Global.cola_amuletos.empty():
				yield(get_tree(), "idle_frame")
			
			repeticiones_posibles -= 1
			
			_call_next_step(i)
			return
		
		
		
		
		var array_final = revisar_amuletos_final()
		
		Global.setear_fifth = true
		
		for i in array_final:
			Global.usar_amuleto_animacion(i)
		
		#codigo ejecutando cosas del array
		
		while !Global.cola_amuletos.empty():
			yield(get_tree(), "idle_frame")
		
		
		
		
		
		
		if !convertir_a_plata:
			GenP.generar_puntos(valor_animado, secuencia_puntaje[secuencia_puntaje.size()-1].posicion, true)
			
			while GenP.generando_moviendo:
				yield(get_tree(), "idle_frame")
		
		valor_animado *= Global.stats.global_mult
		
		if !convertir_a_plata:
			nodo_anim.get_parent().sumar_puntos(valor_animado)
			Global.reproducir_sonido("punto2", get_tree().get_nodes_in_group("camera")[0].global_position, 1.8)
			Global.reproducir_sonido("dice_roll_1", get_tree().get_nodes_in_group("camera")[0].global_position, 1.8)
			nodo_anim.get_parent().shake_reroll()
		else:
			get_tree().root.get_node("Game").recibir_plata("Giant's Tear Drop: ", int(valor_animado))
		
		
		
		
		
		
		var array_post_final = revisar_amuletos_post_final()
		
		for i in array_post_final:
			Global.usar_amuleto_animacion(i)
		
		
		while !Global.cola_amuletos.empty():
			yield(get_tree(), "idle_frame")
		
		
		
		
		if !repetir_play:
			if get_tree().root.get_node("Game").plays_actuales == 0:
				var numero = int(get_tree().root.get_node("Game").puntos_max)
				if numero < get_tree().root.get_node("Game").puntos_por_nivel(get_tree().root.get_node("Game").nivel_actual):
					get_tree().root.get_node("Game").perder()
					return
			
			valor_actual = 0.0
			valor_animado = 0.0
			
			for i in get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children():
				if i.get_node("Sprite-top").visible and !i.get_node("Sprite").visible:
					i.free()
			
			Global.stats.global_mult = 1.0
			get_tree().root.get_node("Game").actualizar_global_mult()
			ejecutando = false
			return
		else:
			var padre = []
			
			for s in get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
				if (typeof(s.padre) == TYPE_INT and (s.padre == 1 or s.padre == 2)):
					padre.append(s)
					break
			
			if padre != [] and padre.size() == 1:
				Ejecutador.ejecutando = false
				if !Ejecutador.ejecutando:
					ejecutar_jugada(padre[0])
					return
			
			return
	
	var paso = secuencia_puntaje[i]
	var domino = paso["domino"]
	var puntos_propios = paso["puntaje_propio"]
	
	nodo_anim.global_position = paso["posicion"] + Vector2(0, -30)
	
	nodo_anim.scale = Vector2(0.25, 0.25)
	
	if paso["mult"] != 1:
		nodo_anim.mostrar_tipo("mult", round(paso["mult"] * 100) / 100.0, 2.0, [20, 50, 40], 0.4)
		nodo_anim.get_parent().shake_reroll()
		yield(get_tree().create_timer(delay_por_domino), "timeout") 
	
	
	if paso["mult_color"] != 1.0:
		nodo_anim.mostrar_tipo("mult", round(paso["mult_color"] * 100) / 100.0, 2.0, [20, 50, 40], 0.4)
		nodo_anim.get_parent().shake_reroll()
		yield(get_tree().create_timer(delay_por_domino), "timeout")
	
	
	valor_animado += puntos_propios
	valor_actual = clamp(valor_animado / puntos_shader_max * 0.8, 0.0, 0.8)
	
	if print_s: print("Shader =", valor_actual, " | Domino:", domino.name, " | Puntos sumados:", puntos_propios, " | Total mostrado:", valor_animado)
	
	nodo_anim.mostrar_tipo("suma", puntos_propios, 2.0, [20, 50, 40], 0.4)
	nodo_anim.get_parent().shake_reroll()
	
	yield(get_tree().create_timer(delay_por_domino), "timeout")
	
	
	for i in paso["array_especiales"]:
		nodo_anim.mostrar_tipo(i[1], i[0], 2.0, [20, 50, 40], 0.4, i[2])
		
		if i[1] == "especial_suma":
			valor_animado += (i[0])
		
		if i[1] == "plata":
			get_tree().root.get_node("Game").recibir_plata("Domino:  ", i[0])
		
		if i[1] == "suma":
			valor_animado += (i[0])
		
		nodo_anim.get_parent().shake_reroll()
		yield(get_tree().create_timer(delay_por_domino), "timeout")
	
	
	Global.contadores_ejecuciones_amuletos = 0
	
	
	for i in paso["array_especiales_amuletos"]:
		Global.contadores_ejecuciones_amuletos += 1
		
		nodo_anim.mostrar_tipo(i[1], i[0], 2.0, [20, 50, 40], 0.4, "", i[2])
		
		if i[1] == "especial_suma":
			valor_animado += (i[0])
		
		if i[1] == "plata":
			get_tree().root.get_node("Game").recibir_plata("Domino:  ", i[0])
		
		if i[1] == "suma":
			valor_animado += (i[0])
		
		nodo_anim.get_parent().shake_reroll()
		yield(get_tree().create_timer(delay_por_domino), "timeout")
		
		if Global.contadores_ejecuciones_amuletos % 5 == 0 and Global.contadores_ejecuciones_amuletos != 0:
			for k in Global.cantidad_fifth():
				nodo_anim.mostrar_tipo(i[1], i[0], 2.0, [20, 50, 40], 0.4, "", "Fifth is the charm")
				
				if i[1] == "especial_suma":
					valor_animado += (i[0])
				
				if i[1] == "plata":
					get_tree().root.get_node("Game").recibir_plata("Domino:  ", i[0])
				
				if i[1] == "suma":
					valor_animado += (i[0])
				
				nodo_anim.get_parent().shake_reroll()
				yield(get_tree().create_timer(delay_por_domino), "timeout")
	
	
	delay_por_domino = max(delay_por_domino * 0.9, 0.1)
	
	
	ultimo = paso
	
	
	if i + 1 >= secuencia_puntaje.size():
		for k in get_tree().root.get_node("Game").amuletos_tenidos:
			match k:
				"Easy Money":
					nodo_anim.mostrar_tipo("plata", int((ultimo["puntaje_max"])/2), 2.0, [20, 50, 40], 0.4, "", "Easy Money")
					get_tree().root.get_node("Game").recibir_plata("Domino:  ", int((ultimo["puntaje_max"])/2))
					
					nodo_anim.get_parent().shake_reroll()
					yield(get_tree().create_timer(delay_por_domino), "timeout")
				
				"Sea Shell":
					if (ultimo["domino"].yo.color.to_lower() == "blue" or ultimo["domino"].yo.color.to_lower() == "all"):
						nodo_anim.mostrar_tipo("plata", int(5), 2.0, [20, 50, 40], 0.4, "", "Sea Shell")
						get_tree().root.get_node("Game").recibir_plata("Domino:  ", 5)
						
						nodo_anim.get_parent().shake_reroll()
						yield(get_tree().create_timer(delay_por_domino), "timeout")
	
	
	_call_next_step(i + 1)


var rng = RandomNumberGenerator.new()


func revisar_stamps(d):
	var array = []
	
	for i in d.yo.stamps:
		if i.has("Ascendant Stamp"):
			var baraja = d.get_parent()
			var puntaje = baraja.mazo_original[d.nombre].puntaje
			
			array.append([2, "especial", "Ascendant Stamp"])
			
			baraja.mazo_original[d.nombre].puntaje = puntaje+2
			d.yo.puntaje = puntaje+2
		
		
		if i.has("Gold Stamp"):
			array.append([5*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Gold Stamp"])
		
		
		if i.has("Silver Stamp"):
			array.append([3*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Silver Stamp"])
		
		
		if i.has("Bronze Stamp"):
			array.append([1*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Bronze Stamp"])
		
		
		if i.has("Emerald Stamp"):
			var plata_acumulada = 0
			
			for k in get_tree().root.get_node("Game/Viewport/Baraja").get_children():
				if !k.get_node("Sprite").visible and (d.yo.color == k.yo.color or d.yo.color == "all"): plata_acumulada += 1
			
			array.append([plata_acumulada*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Emerald Stamp"])
		
		
		if i.has("Quartz Stamp"):
			rng.randomize()
			
			var moneda = bool(rng.randi_range(0, 1))
			
			if moneda:
				array.append([5*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Quartz Stamp"])
			else:
				array.append([5, "suma", "Quartz Stamp"])
		
		
		if i.has("Amethyst Stamp"):
			array.append([0.5, "especial", "Amethyst Stamp"])
			
			Global.stats[d.yo.color.to_lower()+"_mult"] += 0.5
			get_tree().root.get_node("Game").EFECTOS_TEMPORALES.append(["+0.5", d.yo.color.to_lower()+"_mult", 0, true])
		
		
		if i.has("Diamond Stamp"):
			array.append([3, "especial_otro", "Diamond Stamp"])
			
			Global.stats["plata_"+d.yo.color.to_lower()+"_mult"] *= 3
			get_tree().root.get_node("Game").EFECTOS_TEMPORALES.append(["x3", "plata_"+d.yo.color.to_lower()+"_mult", 0, true])
		
		
		if i.has("Obsidian Stamp"):
			array.append([2, "especial_otro", "Obsidian Stamp"])
			
			get_tree().root.get_node("Game").EFECTOS_TEMPORALES.append(["x2",   d.yo.color.to_lower()+"_%", 1, true])
		
		
		if i.has("God Stamp"):
			var puntaje_a_dar = 0
			
			#if print_s: print(secuencia_puntaje)
			
			for paso in secuencia_puntaje:
				var puntos_propios = paso["puntaje_max"]
				
				if puntaje_a_dar < puntos_propios:
					puntaje_a_dar = puntos_propios
			
			#if print_s: print("PUNTOS A DAR:     ", puntaje_a_dar)
			
			array.append([puntaje_a_dar, "especial_suma", "God Stamp"])
	
	
	return array



var rng_amuletos = RandomNumberGenerator.new()


func revisar_amuletos_por_domino(d):
	var cont = 0
	
	rng_amuletos.randomize()
	
	var array = []
	for i in get_tree().root.get_node("Game").amuletos_tenidos:
		rng_amuletos.randomize()
		var bool_random = rng_amuletos.randi_range(0, int(1/Global.cantidad_Augmented_plus_1())) == 0
		match i:
			"Rose Ascendant":
				if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1, "especial_suma", "Rose Ascendant"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+1
					d.yo.puntaje = puntaje+1
			
			"Orange Ascendant":
				if bool_random and (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1, "especial_suma", "Orange Ascendant"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+1
					d.yo.puntaje = puntaje+1
			
			"Blue Ascendant":
				if bool_random and (d.yo.color.to_lower() == "blue" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1, "especial_suma", "Blue Ascendant"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+1
					d.yo.puntaje = puntaje+1
			
			"Green Ascendant":
				if bool_random and (d.yo.color.to_lower() == "green" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1, "especial_suma", "Green Ascendant"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+1
					d.yo.puntaje = puntaje+1
	
	
	
	
			"Domino Paradox":
				var cont_dominos_paradox = 0
				
				for k in get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children():
					if k.get_node("Sprite-top").visible and !k.get_node("Sprite").visible: cont_dominos_paradox += 1
				
				if secuencia_puntaje.size() == 1:
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([10, "especial_suma", "Domino Paradox"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+10
					d.yo.puntaje = puntaje+10
				
				if secuencia_puntaje.size() == cont_dominos_paradox:
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([10, "especial_suma", "Domino Paradox"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+10
					d.yo.puntaje = puntaje+10
	
	
	
	
			"Domino Spirit":
				var cont_dominos_paradox = 0
				
				for k in get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children():
					if k.get_node("Sprite-top").visible and !k.get_node("Sprite").visible: cont_dominos_paradox += 1
				
				if secuencia_puntaje.size() == cont_dominos_paradox:
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([15, "especial_suma", "Domino Spirit"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje+15
					d.yo.puntaje = puntaje+15
	
	
	
	
			"Gold Medal":
				if secuencia_puntaje.size() <= 3:
					secuencia_puntaje[secuencia_puntaje.size()-1]["mult"] += .6
					secuencia_puntaje[secuencia_puntaje.size()-1]["puntaje_propio"] *= 1.6
	
	
	
	
			"Rose Flourish":
				if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1.6, "especial_otro", "Rose Flourish"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
					d.yo.puntaje = puntaje*1.6
			
			"Orange Flourish":
				if bool_random and (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1.6, "especial_otro", "Orange Flourish"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
					d.yo.puntaje = puntaje*1.6
			
			"Blue Flourish":
				if bool_random and (d.yo.color.to_lower() == "blue" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1.6, "especial_otro", "Blue Flourish"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
					d.yo.puntaje = puntaje*1.6
			
			"Green Flourish":
				if bool_random and (d.yo.color.to_lower() == "green" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var baraja = d.get_parent()
					var puntaje = baraja.mazo_original[d.nombre].puntaje
					
					array.append([1.6, "especial_otro", "Green Flourish"])
					
					baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
					d.yo.puntaje = puntaje*1.6
	
	
	
			"Rose Bloom":
				if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					var amuleto =  get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(cont)
					var amuleto1 = get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(cont)
					
					if amuleto.valores_diccionario["Rose Bloom"][1] < 2.0:
						array.append([0.2, "especial", "Rose Bloom"])
						
						amuleto.valores_diccionario["Rose Bloom"][1]  += 0.2
						amuleto1.valores_diccionario["Rose Bloom"][1] += 0.2
						
						get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+0.2", "rose_mult", "Rose Bloom", true])
						
						get_tree().root.get_node("Game").aplicar_efecto("Rose Bloom")
	
	
	
	
	
			"Orange Delight":
				if (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
					array.append([2*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Orange Delight"])
	
	
	
			"Coin Strike":
				if rng_amuletos.randi_range(0, int(4/Global.cantidad_Augmented_plus_1())) == 0:
					array.append([2*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Coin Strike"])
	
	
			"Crystal Dice":
				var a = revisar_amuletos_por_domino_dice(d, cont)
				
				if a != []:
					array.append(a)
	
	
		cont += 1
	
	
	return array


func revisar_amuletos_por_domino_dice(d, cont):
	rng_amuletos.randomize()
	
	
	var amuleto_dice =  get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(cont)
	
	var i = amuleto_dice.valores_diccionario["Crystal Dice"][1]
	
	var array = []
	
	rng_amuletos.randomize()
	var bool_random = rng_amuletos.randi_range(0, int(1/Global.cantidad_Augmented_plus_1())) == 0
	
	match i:
		"Rose Ascendant":
			if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+1
				d.yo.puntaje = puntaje+1
		
		"Orange Ascendant":
			if bool_random and (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+1
				d.yo.puntaje = puntaje+1
		
		"Blue Ascendant":
			if bool_random and (d.yo.color.to_lower() == "blue" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+1
				d.yo.puntaje = puntaje+1
		
		"Green Ascendant":
			if bool_random and (d.yo.color.to_lower() == "green" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+1
				d.yo.puntaje = puntaje+1




		"Domino Paradox":
			var cont_dominos_paradox = 0
			
			for k in get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children():
				if k.get_node("Sprite-top").visible and !k.get_node("Sprite").visible: cont_dominos_paradox += 1
			
			if secuencia_puntaje.size() == 1:
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([10, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+10
				d.yo.puntaje = puntaje+10
			
			if secuencia_puntaje.size() == cont_dominos_paradox:
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([10, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+10
				d.yo.puntaje = puntaje+10




		"Domino Spirit":
			var cont_dominos_paradox = 0
			
			for k in get_tree().root.get_node("Game").get_node("Viewport/Zona_de_specials/Baraja_S").get_children()+get_tree().root.get_node("Game").get_node("Viewport/Baraja").get_children():
				if k.get_node("Sprite-top").visible and !k.get_node("Sprite").visible: cont_dominos_paradox += 1
			
			if secuencia_puntaje.size() == cont_dominos_paradox:
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([15, "especial_suma", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje+15
				d.yo.puntaje = puntaje+15




		"Gold Medal":
			if secuencia_puntaje.size() <= 3:
				secuencia_puntaje[secuencia_puntaje.size()-1]["mult"] += .6
				secuencia_puntaje[secuencia_puntaje.size()-1]["puntaje_propio"] *= 1.6




		"Rose Flourish":
			if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1.6, "especial_otro", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
				d.yo.puntaje = puntaje*1.6
		
		"Orange Flourish":
			if bool_random and (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1.6, "especial_otro", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
				d.yo.puntaje = puntaje*1.6
		
		"Blue Flourish":
			if bool_random and (d.yo.color.to_lower() == "blue" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1.6, "especial_otro", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
				d.yo.puntaje = puntaje*1.6
		
		"Green Flourish":
			if bool_random and (d.yo.color.to_lower() == "green" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var baraja = d.get_parent()
				var puntaje = baraja.mazo_original[d.nombre].puntaje
				
				array.append([1.6, "especial_otro", "Crystal Dice"])
				
				baraja.mazo_original[d.nombre].puntaje = puntaje*1.6
				d.yo.puntaje = puntaje*1.6



		"Rose Bloom":
			if bool_random and (d.yo.color.to_lower() == "rose" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				var amuleto =  get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(cont)
				var amuleto1 = get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(cont)
				
				if amuleto.valores_diccionario["Rose Bloom"][1] < 2.0:
					array.append([0.2, "especial", "Crystal Dice"])
					
					amuleto.valores_diccionario["Rose Bloom"][1]  += 0.2
					amuleto1.valores_diccionario["Rose Bloom"][1] += 0.2
					
					get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+0.2", "rose_mult", "Rose Bloom", true])
					
					get_tree().root.get_node("Game").aplicar_efecto("Crystal Dice")



		"Orange Delight":
			if (d.yo.color.to_lower() == "orange" or d.yo.color.to_lower() == "all"): # Orange, Rose, Blue, Green, All
				array.append([2*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Crystal Dice"])



		"Coin Strike":
			if rng_amuletos.randi_range(0, int(4/Global.cantidad_Augmented_plus_1())) == 0:
				array.append([2*Global.stats["plata_mult"]*Global.stats["plata_"+d.yo.color.to_lower()+"_mult"], "plata", "Crystal Dice"])
	
	
	if array.size() != 0:
		return array[0]
	else:
		return []


var rng_amuletos_final = RandomNumberGenerator.new()


func revisar_amuletos_final():
	var _cont = 0
	
	Global.contadores_amuletos = 0
	
	rng_amuletos_final.randomize()
	
	var array = []
	for i in get_tree().root.get_node("Game").amuletos_tenidos:
		rng_amuletos_final.randomize()
		var _bool_random = rng_amuletos_final.randi_range(0, int(1/Global.cantidad_Augmented_plus_1())) == 0
		match i:
			"Giant's Tear Drop":
				if rng_amuletos_final.randi_range(1, int(20/Global.cantidad_Augmented_plus_1())) == 1:
					array.append("Giant's Tear Drop")
				else:
					array.append("default")
			
			"Black Ink":
				array.append("Black Ink")
			
			"Puzzle Piece":
				array.append("Puzzle Piece")
			
			"Chain Lock":
				array.append("Chain Lock")
			
			"Gold Seed":
				array.append("Gold Seed")
			
			"Gold Tree":
				array.append("Gold Tree")
			
			"Fading Luck":
				array.append("Fading Luck")
			
			"Domino Surge":
				array.append("Domino Surge")
			
			"Combo Trinity":
				array.append("Combo Trinity")
			
			"Chain Dealer":
				array.append("Chain Dealer")
			
			"Overgrowth":
				array.append("Overgrowth")
			
			"Sun Pendant":
				array.append("Sun Pendant")
			
			"Amber Core":
				array.append("Amber Core")
			
			"Stack Overflow":
				array.append("Stack Overflow")
			
			"Final Wish":
				if get_tree().root.get_node("Game").plays_actuales == 0:
					array.append("Final Wish")
				else:
					array.append("default")
			
			"Crystal Dice":
				var a = revisar_amuletos_final_dice(_cont)
				
				if a != "":
					array.append(a)
				else:
					array.append("default")
			
			_:
				array.append("default")
		
		_cont += 1
	
	return array


func revisar_amuletos_final_dice(_cont):
	rng_amuletos_final.randomize()
	
	var amuleto_dice =  get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(_cont)
	
	var i = amuleto_dice.valores_diccionario["Crystal Dice"][1]
	
	var array = []
	
	rng_amuletos_final.randomize()
	var _bool_random = rng_amuletos_final.randi_range(0, int(1/Global.cantidad_Augmented_plus_1())) == 0
	match i:
		"Giant's Tear Drop":
			if rng_amuletos_final.randi_range(1, int(20/Global.cantidad_Augmented_plus_1())) == 1:
				array.append("Giant's Tear Drop1")
		
		"Black Ink":
			array.append("Black Ink1")
		
		"Puzzle Piece":
			array.append("Puzzle Piece1")
		
		"Chain Lock":
			array.append("Chain Lock1")
		
		"Gold Seed":
			array.append("Gold Seed1")
		
		"Gold Tree":
			array.append("Gold Tree1")
		
		"Fading Luck":
			array.append("Fading Luck1")
		
		"Domino Surge":
			array.append("Domino Surge1")
		
		"Combo Trinity":
			array.append("Combo Trinity1")
		
		"Chain Dealer":
			array.append("Chain Dealer1")
		
		"Overgrowth":
			array.append("Overgrowth1")
		
		"Sun Pendant":
			array.append("Sun Pendant1")
		
		"Amber Core":
			array.append("Amber Core1")
		
		"Stack Overflow":
			array.append("Stack Overflow1")
		
		"Final Wish":
			if get_tree().root.get_node("Game").plays_actuales == 0:
				array.append("Final Wish1")
	
	_cont += 1
	
	
	if array.size() != 0:
		return array[0]
	else:
		return ""



var rng_amuletos_post_final = RandomNumberGenerator.new()


func revisar_amuletos_post_final():
	var _cont = 0
	
	Global.contadores_amuletos = 0
	
	rng_amuletos_post_final.randomize()
	
	var array = []
	for i in get_tree().root.get_node("Game").amuletos_tenidos:
		rng_amuletos_post_final.randomize()
		var _bool_random = rng_amuletos_post_final.randi_range(0, int(1/Global.cantidad_Augmented_plus_1())) == 0
		match i:
			"Lucky Break":
				if rng_amuletos_post_final.randi_range(1, int(20/Global.cantidad_Augmented_plus_1())) == 1:
					array.append("Lucky Break")
					repetir_play = true
			
			_:
				array.append("default")
		
		_cont += 1
	
	
	return array


func cambiar_i():
	var cont = 0
	
	for i in get_tree().root.get_node("Game").amuletos_tenidos:
		match i:
			"Echo Pattern":
				repeticiones_posibles += 1
				repeticiones_posibles_array.append("Echo Pattern")
			
			"Crystal Dice":
				var a = cambiar_i_dice(cont)
				
				repeticiones_posibles += a
				repeticiones_posibles_array.append("Echo Pattern1")
		
		cont += 1
	
	if repeticiones_posibles != 0:
		return true


func cambiar_i_dice(_cont):
	var amuleto_dice =  get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(_cont)
	
	var i = amuleto_dice.valores_diccionario["Crystal Dice"][1]
	
	var temp_repeticiones_posibles = 0
	
	match i:
		"Echo Pattern":
			temp_repeticiones_posibles += 1
	
	return temp_repeticiones_posibles
