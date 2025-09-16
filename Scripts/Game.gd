extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}


var estaciones = {  "seleccion_nivel" : -1000,
					"tienda" : 1000,
					"nivel" : 0
}

var baraja_activa = "baraja"

var anim_agrandarse_played = false

var bandera_nivel = false

var nivel_actual = 1

var actualizado = false

onready var camara = get_node("Viewport/Camera2D")
var estacion_actual = "seleccion_nivel"

var domino_a_borrar = null
var domino_a_comprar = null

var semilla

var puntos_actuales = 0

var estacion_aux


func _ready():
	randomize()
	semilla = randi()
	seed(semilla)
	print(semilla)
	estacion_aux = estacion_actual
	estacion_actual = "transicion"
	
	seed(10)
	
	$Viewport/Menu_info_BG.visible = true
	get_node("Viewport/1").position.x = estaciones[estacion_aux]


func puntos_por_nivel(nivel: int) -> int:
	if nivel <= 0:
		return 0
	
	var base := 80
	var crecimiento := 1.15
	var variacion := 10
	
	var puntos = base * pow(crecimiento, nivel - 1)
	
	# variación fija por nivel
	var pseudo_rand = int(hash(nivel) % variacion)
	puntos += pseudo_rand
	
	return int(round(puntos))


var _puntos_temp := 0 setget _set_puntos_temp
var _boing_activo := false


func sumar_puntos(puntos):
	#var label = get_node("Viewport/Zona_de_cosas/Points_A")
	var puntos_iniciales = _puntos_temp
	var puntos_finales = puntos_actuales + puntos
	var duracion = 0.2
	
	# sumamos puntos siempre
	puntos_actuales += puntos
	
	# Tween para numero progresivo
	var tween_val = Tween.new()
	tween_val.name = "analisa"
	add_child(tween_val)
	tween_val.interpolate_property(self, "_puntos_temp", puntos_iniciales, puntos_finales, duracion, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_val.start()
	tween_val.connect("tween_all_completed", tween_val, "queue_free")
	
	# si el boing ya está activo, no hacemos otra animación
	if _boing_activo:
		return
	
	_boing_activo = true
	
	# Boing con Tween clásico
	#var escala_base = label.rect_scale
	#var rot_base = label.rect_rotation
	#var fuerza = clamp(float(puntos) * 0.1, 1.0, 2.0)
	#var escala_boing = escala_base * fuerza
	#var angulo = puntos / 10
	
	#var tween = Tween.new()
	#add_child(tween)
	
	# primer tramo: subir escala + rotar
	#tween.interpolate_property(label, "rect_scale", label.rect_scale, escala_boing, 0.15, Tween.TRANS_BACK, Tween.EASE_OUT)
	#tween.interpolate_property(label, "rect_rotation", rot_base, rot_base + angulo, 0.15, Tween.TRANS_SINE, Tween.EASE_OUT)
	
	# segundo tramo: volver a escala base + rotacion base
	#tween.interpolate_property(label, "rect_scale", escala_boing, escala_base, 0.25, Tween.TRANS_BACK, Tween.EASE_OUT, 0.15)
	#tween.interpolate_property(label, "rect_rotation", rot_base + angulo, rot_base, 0.25, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.15)
	
	#tween.connect("tween_all_completed", self, "_on_boing_finished")
	#tween.start()


func _on_boing_finished():
	_boing_activo = false


func _set_puntos_temp(v):
	_puntos_temp = v
	$Viewport/Zona_de_cosas/Points_A.bbcode_text = "[wave amp=50 freq=2]\n"+str(int(_puntos_temp))+"\n[/wave]"
	
	#var ancho_por_char = 0.8  # tamaño aproximado por caracter en px, ajusta según fuente
	var texto_A = $Viewport/Zona_de_cosas/Points_A.bbcode_text.replace("[wave amp=50 freq=2]", "").replace("[/wave]", "").strip_edges()
	var texto_M = $Viewport/Zona_de_cosas/Points_M.bbcode_text.replace("[right][wave amp=50 freq=2]", "").replace("[/wave][/right]", "").strip_edges()

	# Elegir el mas largo
	var texto_numeros_length = max(texto_A.length(), texto_M.length())
	
	#print("size: ", $Viewport/Zona_de_cosas/NinePatchRect.rect_size.y, "     offset: ", $Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y)
	#print(texto_numeros_length)
	
	if texto_numeros_length == 1:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 111
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 150
	
	if texto_numeros_length == 2:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 111
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 150
	
	if texto_numeros_length == 3:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 122
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 148
	
	if texto_numeros_length == 4:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 144
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 144
	
	if texto_numeros_length == 5:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 176
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 139
	
	if texto_numeros_length == 6:
		$Viewport/Zona_de_cosas/NinePatchRect.rect_size.y = 200
		$Viewport/Zona_de_cosas/NinePatchRect.rect_pivot_offset.y = 133.95


func _physics_process(_delta):
	$Viewport/Camera2D/FPS.text = str(Engine.get_frames_per_second())
	
	if Input.is_action_pressed("subir_puntos") and estacion_actual == "nivel" and !bandera_nivel:
		sumar_puntos(5)
	
	Global.bandera_mouse = false
	
	if estacion_actual == "transicion":
		#get_node("Viewport/Zona_de_interfaz/Select/1").position.y = lerp(get_node("Viewport/Zona_de_interfaz/Select/1").position.y, 15, 0.1)
		var nodo = get_node("Viewport/Zona_de_interfaz/Select/1")
		
		var tween: Tween = nodo.get_node_or_null("TweenMover")
		
		if tween == null:
			tween = Tween.new()
			tween.name = "TweenMover"
			nodo.add_child(tween)
		
		# Cancelamos cualquier tween anterior
		var _a = tween.stop_all()
		
		# Interpolamos la posición con rebote y guardamos el retorno en _a
		_a = tween.interpolate_property(
			nodo, "position:y", nodo.position.y, 15,
			0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.4
		)
		
		_a = tween.interpolate_property(
			get_node("Viewport/Zona_de_interfaz/Select/2"), "position:x",
			get_node("Viewport/Zona_de_interfaz/Select/2").position.x, -144.562,
			1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		
		_a = tween.interpolate_property(
			get_node("Viewport/Zona_de_interfaz/Select/Menu/1"), "position:x",
			get_node("Viewport/Zona_de_interfaz/Select/Menu/1").position.x, 288,
			1, Tween.TRANS_CUBIC, Tween.EASE_OUT
		)
		
		_a = tween.start()
		
		estacion_actual = "seleccion_nivel"
	
	
	if estacion_actual == "seleccion_nivel" and !actualizado:
		actualizar_escenario_seleccion_nivel()
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	var posision = get_global_mouse_position()
	
	if estacion_actual == "transicion":
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_aux], 0)
		else:
			camara.position = Vector2(estaciones[estacion_aux], 0)
			$Viewport/Icon.position = Vector2(estaciones[estacion_aux], 0)
	else:
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_actual], 0)
		else:
			camara.position = Vector2(estaciones[estacion_actual], 0)
			$Viewport/Icon.position = Vector2(estaciones[estacion_actual], 0)
	
	
	var menu = get_node("Viewport/Menu")
	
	
	if baraja_activa == "Deck":
		if Input.is_action_just_pressed("ui_cancel"):
			baraja_activa = "baraja"
			var tween: Tween = get_node_or_null("TweenMoverInfo")
			
			if tween == null:
				tween = Tween.new()
				tween.name = "TweenMoverInfo"
				add_child(tween)
			
			# Cancelamos cualquier tween anterior
			var _a = tween.stop_all()
			
			# Interpolamos la posición con rebote y guardamos el retorno en _a
			_a = tween.interpolate_property(
				get_node("Viewport/Menu_info"), "position:y", get_node("Viewport/Menu_info").position.y, 350,
				0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 0
			)
			_a = tween.interpolate_property(
				get_node("Viewport/Menu_info_BG"), "modulate:a8", get_node("Viewport/Menu_info_BG").modulate.a8, 0,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0
			)
			
			_a = tween.start()
	
	
	if estacion_actual == "nivel" and baraja_activa == "baraja" or baraja_activa == "baraja_especial":
		var numero = int($Viewport/Zona_de_cosas/Points_A.text)
		if numero >= puntos_por_nivel(nivel_actual):
			pasar_level()
		
		if true:
			var diferencia = Vector2(40, 24)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > $Viewport/Zona_de_specials/Specials1.global_position.x - diferencia.x and pos.x < $Viewport/Zona_de_specials/Specials1.global_position.x + diferencia.x
			var dentro_y = pos.y > $Viewport/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_specials/Specials1.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				diferencia = Vector2(14, 24)
				pos = get_global_mouse_position()
				dentro_x = pos.x > $Viewport/Zona_de_specials/Specials1.global_position.x - diferencia.x and pos.x < $Viewport/Zona_de_specials/Specials1.global_position.x + diferencia.x
				dentro_y = pos.y > $Viewport/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_specials/Specials1.global_position.y + diferencia.y
				dentro = dentro_x and dentro_y
				
				if dentro:
					if !Global.bandera_mouse:
						Global.bandera_mouse = true
				
				if $Viewport/Zona_de_specials/Specials1.position.y > -59:
					$Viewport/Zona_de_specials/Specials1.position.y -= 1
			else:
				if $Viewport/Zona_de_specials/Specials1.position.y < -43:
					$Viewport/Zona_de_specials/Specials1.position.y += 1
		
		
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible:
				continue
			
			# diferencias por nombre
			var diffs = {
				"Delete": Vector2(23, 10),
				"Play": Vector2(23, 10),
				"Deck": Vector2(23, 10)
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				# aca pones lo que ya tenias para hover/click de cada boton
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					# acciones de click segun el nombre
					match boton.name:
						"Play":
							boton.position = Vector2(227.143, 28+2)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.3)
						"Deck":
							boton.position = Vector2(227.143, 81+2)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.3)
						"Delete":
							if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
								if !$Viewport/Baraja.dragging:
									boton.position = Vector2(227.143, 54+2)
								boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
								boton.get_node("Play_sprites/Shaw").visible = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.3)
							if $Viewport/Baraja.dragging:
								domino_a_borrar = $Viewport/Baraja.dragging
								domino_a_borrar.scale = domino_a_borrar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								
								Global.usar_offset = false
								
								var anim = boton.get_node("Play_sprites/AnimationPlayer")
								if !anim.is_playing() and anim_agrandarse_played == false:
									anim.play("agrandarse")
									anim_agrandarse_played = true
								domino_a_borrar.scale_puede_cambiar = false
								#print("ASKJHED")
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "Play":
							$Viewport/Baraja.draw_cards(8)
						
						if boton.name == "Deck":
							baraja_activa = "Deck"
							var tween: Tween = get_node_or_null("TweenMoverInfo")
							
							if tween == null:
								tween = Tween.new()
								tween.name = "TweenMoverInfo"
								add_child(tween)
							
							# Cancelamos cualquier tween anterior
							var _a = tween.stop_all()
							
							# Interpolamos la posición con rebote y guardamos el retorno en _a
							_a = tween.interpolate_property(
								get_node("Viewport/Menu_info"), "position:y", get_node("Viewport/Menu_info").position.y, 0,
								0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 0
							)
							_a = tween.interpolate_property(
								get_node("Viewport/Menu_info_BG"), "modulate:a8", get_node("Viewport/Menu_info_BG").modulate.a8, 100,
								0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0
							)
							
							_a = tween.start()
					
					# reset valores segun boton
					match boton.name:
						"Play":
							boton.position = Vector2(227.143, 28)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
							boton.get_node("Play_sprites/Shaw").visible = true
						"Deck":
							boton.position = Vector2(227.143, 81)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
							boton.get_node("Play_sprites/Shaw").visible = true
						"Delete":
							boton.position = Vector2(227.143, 54)
							if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
								boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
								boton.get_node("Play_sprites/Shaw").visible = true
							if domino_a_borrar:
								$Viewport/Baraja.last_hovered_card = null
								$Viewport/Baraja.arrastrado = null
								$Viewport/Baraja.dragging = null
								domino_a_borrar.queue_free()
								anim_agrandarse_played = false
								Global.usar_offset = true
								var anim = boton.get_node("Play_sprites/AnimationPlayer")
								
								var frame_actual = anim.current_animation_position
								var duracion_actual = anim.current_animation_length
								
								anim.play("achicarse")
								anim.seek(duracion_actual - frame_actual, true)
								domino_a_borrar = null
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				boton.get_node("Play_sprites/Sprite").use_parent_material = false
				match boton.name:
					"Play":
						boton.position = Vector2(227.143, 28)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
						boton.get_node("Play_sprites/Shaw").visible = true
					"Deck":
						boton.position = Vector2(227.143, 81)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
						boton.get_node("Play_sprites/Shaw").visible = true
					"Delete":
						boton.position = Vector2(227.143, 54)
						if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
							boton.get_node("Play_sprites/Shaw").visible = true
						if domino_a_borrar:
							domino_a_borrar.scale = domino_a_borrar.scale.linear_interpolate(Vector2(1, 1), 0.1)
							var anim = boton.get_node("Play_sprites/AnimationPlayer")
							
							var frame_actual = anim.current_animation_position
							var duracion_actual = anim.current_animation_length
							
							Global.usar_offset = true
							anim.play("achicarse")
							anim.seek(duracion_actual - frame_actual, true)
							domino_a_borrar.scale_puede_cambiar = true
							anim_agrandarse_played = false
							domino_a_borrar = null
	
	
	if estacion_actual == "seleccion_nivel":
		menu = get_node("Viewport/Zona_de_interfaz/Select/Menu/1")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "fondo":
				continue
			
			var diffs = {
				"GO":    Vector2(35, 20),
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				# aca pones lo que ya tenias para hover/click de cada boton
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"GO":
							boton.position = Vector2(-19.8+0.8, -11.25+0.8)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "GO":
							cambiar_estacion()
					
					# reset valores segun boton
					match boton.name:
						"GO":
							boton.position = Vector2(-19.8, -11.25)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"GO":
						boton.position = Vector2(-19.8, -11.25)
						boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false
	
	if estacion_actual == "tienda":
		menu = get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "fondo":
				continue
			
			var diffs = {
				"GO":    Vector2(35, 20),
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				# aca pones lo que ya tenias para hover/click de cada boton
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"GO":
							boton.position = Vector2(-19.8+0.8, -11.25+0.8)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "GO":
							cambiar_estacion()
					
					# reset valores segun boton
					match boton.name:
						"GO":
							boton.position = Vector2(-19.8, -11.25)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"GO":
						boton.position = Vector2(-19.8, -11.25)
						boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false
		
		
		menu = get_node("Viewport/Zona_de_tienda/Menu")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible:
				continue
			
			# diferencias por nombre
			var diffs = {
				"Buy": [Vector2(40, 40), Vector2(5, -5)]
			}
			
			var diferencia = diffs[boton.name][0]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x + diffs[boton.name][1].x and pos.x < boton.global_position.x + diferencia.x + diffs[boton.name][1].x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y + diffs[boton.name][1].y and pos.y < boton.global_position.y + diferencia.y + diffs[boton.name][1].y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				# aca pones lo que ya tenias para hover/click de cada boton
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					# acciones de click segun el nombre
					match boton.name:
						"Buy":
							boton.position = Vector2(227.143, 54+3)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
							
							if $Viewport/Zona_de_tienda/Baraja_normales.dragging:
								domino_a_comprar = $Viewport/Zona_de_tienda/Baraja_normales.dragging
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
					
					# reset valores segun boton
					match boton.name:
						"Buy":
							boton.position = Vector2(227.143, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 3)
							boton.get_node("Play_sprites/Shaw").visible = true
							
							if domino_a_comprar:
								$Viewport/Zona_de_tienda/Baraja_normales.last_hovered_card = null
								$Viewport/Zona_de_tienda/Baraja_normales.arrastrado = null
								$Viewport/Zona_de_tienda/Baraja_normales.dragging = null
								domino_a_comprar.queue_free()
								Global.usar_offset = true
								domino_a_comprar = null
					
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites/Sprite").use_parent_material = false
				match boton.name:
					"Buy":
						boton.position = Vector2(227.143, 54)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 3)
						boton.get_node("Play_sprites/Shaw").visible = true
						
						if domino_a_comprar:
							domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(1, 1), 0.1)
							Global.usar_offset = true
							domino_a_comprar.scale_puede_cambiar = true
							anim_agrandarse_played = false
							domino_a_comprar = null


func cambiar_estacion() -> void:
	var proxima_estacion = null
	match estacion_actual:
		"seleccion_nivel":
			proxima_estacion = "nivel"
		"tienda":
			proxima_estacion = "seleccion_nivel"
		"nivel":
			proxima_estacion = "tienda"
	
	desaparecer(estaciones[proxima_estacion])


func desaparecer(destino: float) -> void:
	var tween: Tween = get_node_or_null("TweenMover")
	if tween != null:
		tween.queue_free()
	tween = Tween.new()
	tween.name = "TweenMover"
	add_child(tween)
	var _a = tween.stop_all()
	
	# Suave al salir
	_a = tween.interpolate_property(
		$Viewport/Menu, "position:x", $Viewport/Menu.position.x, 100,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_botones, "rect_position:x", $Viewport/Zona_de_botones.rect_position.x, 306,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_baraja, "rect_position:y", $Viewport/Zona_de_baraja.rect_position.y, 400,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_tienda, "position:y", $Viewport/Zona_de_tienda.position.y, -400,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Baraja, "position:y", $Viewport/Baraja.position.y, 400,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_cosas, "position:y", $Viewport/Zona_de_cosas.position.y, -400,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/linea2, "position:y", $Viewport/linea2.position.y, -500,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/linea, "position:y", $Viewport/linea.position.y, -500,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/1"), "position:y",
		get_node("Viewport/Zona_de_interfaz/Select/1").position.y, -227,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1").position.x, 450,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/2"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/2").position.x, -450,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1").position.x, 450,
		1, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_specials"), "position:y",
		get_node("Viewport/Zona_de_specials").position.y, 331,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	
	if not tween.is_connected("tween_all_completed", self, "_on_desaparecer_completo"):
		_a = tween.connect("tween_all_completed", self, "_on_desaparecer_completo", [destino, estacion_actual])
	
	_a = tween.start()


func aparecer() -> void:
	var tween: Tween = get_node_or_null("TweenMover")
	if tween != null:
		tween.queue_free()
	tween = Tween.new()
	tween.name = "TweenMover"
	add_child(tween)
	
	var _a = tween.stop_all()
	
	# Overshoot al entrar
	_a = tween.interpolate_property(
		$Viewport/Menu, "position:x", $Viewport/Menu.position.x, 0,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_botones, "rect_position:x", $Viewport/Zona_de_botones.rect_position.x, 203.143,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_baraja, "rect_position:y", $Viewport/Zona_de_baraja.rect_position.y, 40,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_tienda, "position:y", $Viewport/Zona_de_tienda.position.y, 0,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Baraja, "position:y", $Viewport/Baraja.position.y, 84.448,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_cosas, "position:y", $Viewport/Zona_de_cosas.position.y, -130,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/linea2, "position:y", $Viewport/linea2.position.y, -111.373,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/linea, "position:y", $Viewport/linea.position.y, -111,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/1"), "position:y",
		get_node("Viewport/Zona_de_interfaz/Select/1").position.y, 15,
		1, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1").position.x, 288,
		1, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/2"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/2").position.x, -144.562,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1").position.x, 288,
		1, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_specials"), "position:y",
		get_node("Viewport/Zona_de_specials").position.y, 199,
		1, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	
	if not tween.is_connected("tween_all_completed", self, "_on_aparecer_completo"):
		_a = tween.connect("tween_all_completed", self, "_on_aparecer_completo", [estacion_actual])
	
	_a = tween.start()


func _on_desaparecer_completo(destino: float, estacion) -> void:
	if estacion == "seleccion_nivel":
		get_node("Viewport/Zona_de_cosas/Level/Num").bbcode_text = "[center]\n"+str(nivel_actual)+"\n[/center]"
		$Viewport/Zona_de_cosas/Points_M.bbcode_text = "[right][wave amp=50 freq=2]\n "+str(puntos_por_nivel(nivel_actual))+" \n[/wave][/right]"
		_set_puntos_temp(0)
	
	_tween_to(destino)


func _on_aparecer_completo(estacion) -> void:
	if estacion == "nivel":
		_set_puntos_temp(0)
		$Viewport/Baraja.draw_cards(8)
		bandera_nivel = false


func _tween_to(destino: float) -> void:
	match estacion_actual:
		"seleccion_nivel":
			estacion_actual = "nivel"
		"tienda":
			estacion_actual = "seleccion_nivel"
		"nivel":
			estacion_actual = "tienda"
	
	get_node("Viewport/1").position.x = destino
	
	var posision = get_global_mouse_position()
	
	if estacion_actual == "transicion":
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_aux], 0)
		else:
			camara.position = Vector2(estaciones[estacion_aux], 0)
			$Viewport/Icon.position = Vector2(estaciones[estacion_aux], 0)
	else:
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_actual], 0)
		else:
			camara.position = Vector2(estaciones[estacion_actual], 0)
			$Viewport/Icon.position = Vector2(estaciones[estacion_actual], 0)
	
	aparecer()


func actualizar_escenario_seleccion_nivel():
	get_node("Viewport/Zona_de_interfaz/Select/1/Level/Num").bbcode_text = "[center]\n"+str(nivel_actual)+"\n[/center]"
	get_node("Viewport/Zona_de_interfaz/Select/1/Points").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(puntos_por_nivel(nivel_actual))+""+"\n[/wave][/center]"
	var letras =  get_node("Viewport/Zona_de_interfaz/Select/1/Points").bbcode_text.length()-str("\n[/wave][/center]"+"[center][wave amp=50 freq=2]\n").length()
	get_node("Viewport/Zona_de_interfaz/Select/1/NinePatchRect").rect_size.y = (letras)*15
	get_node("Viewport/Zona_de_interfaz/Select/1/NinePatchRect").rect_position.y = -8.5
	
	var resultado
	
	match letras:
		2:
			resultado = -15
		3:
			get_node("Viewport/Zona_de_interfaz/Select/1/NinePatchRect").rect_size.y += 1
			resultado = -11
		4:
			get_node("Viewport/Zona_de_interfaz/Select/1/NinePatchRect").rect_size.y += 1
			resultado = -7
		5:
			resultado = -4
		6:
			resultado = -0.25
	
	get_node("Viewport/Zona_de_interfaz/Select/1/NinePatchRect").rect_position.x = resultado
	
	actualizado = true


func pasar_level():
	if !bandera_nivel:
		nivel_actual += 1
		puntos_actuales = 0
		_puntos_temp = 0
		
		
		$Viewport/Baraja.last_hovered_card = null
		$Viewport/Baraja.arrastrado = null
		$Viewport/Baraja.dragging = null
		
		for i in $Viewport/Baraja.get_children():
			i.queue_free()
		
		anim_agrandarse_played = false
		Global.usar_offset = true
		
		
		if has_node("analisa"):
			get_node("analisa").queue_free()
		
		
		print("AHKJSDHASD")
		
		cambiar_estacion()
		
		actualizar_escenario_seleccion_nivel()
		
		bandera_nivel = true
