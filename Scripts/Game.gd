extends Node2D


var botonHover =   {"Play"              : false,
					"Deck"              : false,
					"Draw"              : false,
					"GO"                : false,
					"GO1"               : false,
					"Buy"               : false,
					"Reroll_Normal"     : false,
					"Reroll_Charms"     : false,
					"Reroll_Specials"   : false,
					"Delete"            : false,
					"Options"           : false,
					"Quit"              : false,
					"Discord"           : false,
}

var amuletos_instancia = preload("res://Scenas/Amuletos_de_menu.tscn")
var Specials_tienda_tenidos = preload("res://Scenas/Specials_tienda_tenidos.tscn")

var bandera_de_menus_movedisos = false

var bandera_colores_mult = false

onready var botonPosision =  {  "Play"                  : {"global_position" : Vector2(230, -129)},
								"Draw"                  : {"global_position" : get_node("Viewport/Menu/Draw").global_position},
								"Deck"                  : {"global_position" : get_node("Viewport/Menu/Deck").global_position},
								"Delete"                : {"global_position" : get_node("Viewport/Menu/Delete").global_position},
								"GO"                    : {"global_position" : Vector2(-785.057007, 118)},
								"GO1"                   : {"global_position" : Vector2(1214.943115, 118)},
								"Buy"                   : {"global_position" : Vector2(1078.143066, -58)},
								"Reroll_Normal"         : {"global_position" : Vector2(800, 15)},
								"Reroll_Charms"         : {"global_position" : Vector2(1215, 25)},
								"Reroll_Specials"       : {"global_position" : Vector2(922, 32)},
}


var estaciones = {  "seleccion_nivel" : -1000,
					"tienda" : 1000,
					"nivel" : 0
}

var cashout = []

var baraja_origen

var bandera_go_seleccion = false
var bandera_go_tienda    = false
var bandera_para_botones = false

var menu_actual = "Cartas_normales"

var draws_actuales = Global.stats.draws
var plays_actuales = Global.stats.plays

var plata = Global.stats.start_money

var baraja_activa = "baraja"

var anim_agrandarse_played = false

var bandera_nivel = true

var nivel_actual = 1

var actualizado = false

onready var camara = get_node("Viewport/Camera2D")
var estacion_actual = "seleccion_nivel"

var domino_a_borrar = null
var domino_a_comprar = null

var semilla

var amuletos_tenidos = []

var puntos_actuales = 0

var estacion_aux

# en tu singleton Global.gd (o en este script arriba):
var cartas_dibujadas = {
	"Cartas_normales": false,
	"Cartas_Specials": false,
	"COMBOS": false
}



func _ready():
	var _s = get_node("Viewport/Open_charm/tope/AnimationPlayer").connect(
		"animation_finished",
		self,
		"_on_animation_finished"
	)
	
	randomize()
	semilla = randi()
	seed(semilla)
	print(semilla)
	estacion_aux = estacion_actual
	estacion_actual = "transicion"
	
	#seed(10)
	
	$Viewport/Menu_info_BG.visible = true
	get_node("Viewport/1").position.x = estaciones[estacion_aux]


var rng := RandomNumberGenerator.new()


func puntos_por_nivel(nivel: int) -> int:
	if nivel <= 0:
		return 0
	
	var base := 80
	var crecimiento := 1.15
	var variacion := 10
	
	var puntos = base * pow(crecimiento, nivel - 1)
	
	# variacion determinista en base a la semilla y el nivel
	rng.seed = (semilla + nivel)
	var pseudo_rand = rng.randi_range(0, variacion - 1)
	puntos += pseudo_rand
	
	return int(round(puntos))


func plata_por_nivel(nivel: int) -> int:
	if nivel <= 0:
		return 0
	
	var base := 10
	var crecimiento := 1.0 #1.15
	var variacion := 3
	
	var plata1 = base * pow(crecimiento, nivel - 1)
	
	# variacion determinista en base a la semilla y el nivel
	rng.seed = (semilla + nivel)
	var pseudo_rand = rng.randi_range(0, variacion - 1)
	plata1 += pseudo_rand
	
	if !Global.plata_mucha:
		return int(round(plata1))
	else:
		return int(round(plata1))*20


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
	$Viewport/Zona_de_cosas/Money_level.bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata_por_nivel(nivel_actual))+Global.prefix_plata+"\n[/wave]"
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


var bandera_dominos = false
var amuleto_siendo_usado = ""


func _physics_process(_delta):
	if charm_shaking == 1 or charm_shaking == 2:
		charm_shake_time += _delta
		
		# onda senoidal → rotacion izquierda/derecha
		# usa *deg2rad()* porque Godot 3 rota en radianes
		#get_node("Viewport/Open_charm").rotation = sin(charm_shake_time * charm_shake_speed) * deg2rad(charm_shake_strength)
		
		dissolve_value = min(1.0, dissolve_value + _delta * dissolve_speed)
		_aplicar_dissolve(dissolve_value)
		
		# si queres que se detenga después de un tiempo:
		if charm_shake_time >= 0.6 and charm_shaking == 1:
			get_node("Viewport/Open_charm/tope/AnimationPlayer").play("Nueva Animación")
			charm_shaking = 2
			#get_node("Viewport/Open_charm").rotation = 0
			dissolve_value = 1.0
			_aplicar_dissolve(1.0)
	
	
	camara.get_node("Camera2D/FPS").text = str(Engine.get_frames_per_second())
	
	if Input.is_action_pressed("subir_puntos") and estacion_actual == "nivel" and !bandera_nivel and (baraja_activa == "baraja" or baraja_activa == "baraja_especial"):
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
			$Viewport/Zona_de_interfaz/fondo, "position:x", $Viewport/Zona_de_interfaz/fondo.position.x, -870.14,
			1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		_a = tween.interpolate_property(
			get_node("Viewport/Zona_de_interfaz/2"), "position:x", get_node("Viewport/Zona_de_interfaz/2").position.x, -870.143,
			1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
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
	
	if estacion_actual == "nivel":
		var cont = 0
		for s in get_node("Viewport/Baraja").get_children():
			if !s.get_node("Sprite").visible:
				cont += 1
		
		for s in get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
			if !s.get_node("Sprite").visible:
				cont += 1
		
		#print($"Viewport/Zona_de_interfaz/Nivel/1".position.y)
		
		#print(cont)
		
		if cont != 0:
			if $"Viewport/Zona_de_interfaz/Nivel/1".position.y == -227:
				var tween: Tween = get_node_or_null("TweenMoverDeBotonPlay")
				
				if tween != null:
					tween.queue_free()
				
				tween = Tween.new()
				tween.name = "TweenMoverDeBotonPlay"
				add_child(tween)
				
				var _a = tween.stop_all()
				
				_a = tween.interpolate_property(
					$"Viewport/Zona_de_interfaz/Nivel/1", "position:y", $"Viewport/Zona_de_interfaz/Nivel/1".position.y, -179,
					1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
				)
				
				$"Viewport/Zona_de_interfaz/Nivel/1".position.y = -226
				
				_a = tween.start()
		else:
			if $"Viewport/Zona_de_interfaz/Nivel/1".position.y == -179:
				var tween: Tween = get_node_or_null("TweenMoverDeBotonPlay")
				
				if tween != null:
					tween.queue_free()
				
				tween = Tween.new()
				tween.name = "TweenMoverDeBotonPlay"
				add_child(tween)
				
				var _a = tween.stop_all()
				
				_a = tween.interpolate_property(
					$"Viewport/Zona_de_interfaz/Nivel/1", "position:y", $"Viewport/Zona_de_interfaz/Nivel/1".position.y, -227,
					1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
				)
				
				$"Viewport/Zona_de_interfaz/Nivel/1".position.y = -180
				
				_a = tween.start()
	
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
	
	
	if baraja_activa == "Deck" or baraja_activa == "Deck1":
		if menu_actual == "Cartas_normales":
			if not cartas_dibujadas["Cartas_normales"]:
				$Viewport/Menu_info/Cartas_normales/Rojo.draw_cards("naranja")
				$Viewport/Menu_info/Cartas_normales/Azul.draw_cards("rosa")
				$Viewport/Menu_info/Cartas_normales/Verde.draw_cards("azul")
				$Viewport/Menu_info/Cartas_normales/Amarillo.draw_cards("verde")
				
				cartas_dibujadas["Cartas_normales"] = true
		
		if menu_actual == "Cartas_Specials":
			if not cartas_dibujadas["Cartas_Specials"]:
				# aqui cuando tengas el draw de specials
				cartas_dibujadas["Cartas_Specials"] = true
		
		if menu_actual == "COMBOS":
			if not cartas_dibujadas["COMBOS"]:
				# aqui cuando tengas el draw de combos
				cartas_dibujadas["COMBOS"] = true
		
		
		if menu_actual == "Cartas_normales":
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = false
			
			$Viewport/Menu_info/Cartas_normales.visible = true
			$Viewport/Menu_info/Cartas_especiales.visible = false
			$Viewport/Menu_info/COMBOS.visible = false
		
		
		if menu_actual == "Cartas_Specials":
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = false
			
			$Viewport/Menu_info/Cartas_especiales.visible = true
			$Viewport/Menu_info/COMBOS.visible = false
			$Viewport/Menu_info/Cartas_normales.visible = false
		
		
		if menu_actual == "COMBOS":
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = false
			
			$Viewport/Menu_info/COMBOS.visible = true
			$Viewport/Menu_info/Cartas_especiales.visible = false
			$Viewport/Menu_info/Cartas_normales.visible = false
		
		
		for boton in $"Viewport/Menu_info/Botones".get_children():
			var mouse_pos = get_global_mouse_position()
			var rect = Rect2(boton.rect_global_position, boton.rect_size)
			
			if rect.has_point(mouse_pos):
				Global.bandera_mouse = true
				boton.material.set_shader_param("to_color", Color("#2e624b"))
				
				# Mientras mantengas apretado
				if Input.is_action_pressed("click"):
					boton.rect_position.y = -10
					boton.get_node("Sombra").rect_position.y = 0
				
				# Cuando sueltes
				if Input.is_action_just_released("click"):
					boton.rect_position.y = -12
					boton.get_node("Sombra").rect_position.y = 2
					
					#print("Click soltado sobre:", boton.name)
					
					if boton.name == "Common Dominos":
						menu_actual = "Cartas_normales"
					elif boton.name == "Specials Dominos":
						menu_actual = "Cartas_Specials"
					elif boton.name == "COMBOS":
						menu_actual = "COMBOS"
			else:
				boton.rect_position.y = -12
				boton.get_node("Sombra").rect_position.y = 2
				boton.material.set_shader_param("to_color", Color("#346c53"))
		
		
		if Input.is_action_just_pressed("ui_cancel"):
			cartas_dibujadas = {
				"Cartas_normales": false,
				"Cartas_Specials": false,
				"COMBOS": false
			}
			
			for i in $Viewport/Menu_info/Cartas_normales/Rojo.get_children():
				i.free()
			for i in $Viewport/Menu_info/Cartas_normales/Azul.get_children():
				i.free()
			for i in $Viewport/Menu_info/Cartas_normales/Verde.get_children():
				i.free()
			for i in $Viewport/Menu_info/Cartas_normales/Amarillo.get_children():
				i.free()
			
			# aca usas la baraja de origen, no menu_actual
			baraja_activa = baraja_origen
			
			
			var tween: Tween = get_node_or_null("TweenMoverInfo")
			if tween == null:
				tween = Tween.new()
				tween.name = "TweenMoverInfo"
				add_child(tween)
			
			var _a = tween.stop_all()
			
			_a = tween.interpolate_property(
				get_node("Viewport/Menu_info"), "position:y", get_node("Viewport/Menu_info").position.y, 350,
				0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 0
			)
			_a = tween.interpolate_property(
				get_node("Viewport/Menu_info_BG"), "modulate:a8", get_node("Viewport/Menu_info_BG").modulate.a8, 0,
				0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0
			)
			_a = tween.start()
	
	
	if estacion_actual == "nivel" and !Ejecutador.ejecutando:
		if !bandera_colores_mult:
			$Viewport/Menu_info/Cartas_normales/O_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.orange_mult
			$Viewport/Menu_info/Cartas_normales/R_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.rose_mult
			$Viewport/Menu_info/Cartas_normales/A_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.blue_mult
			$Viewport/Menu_info/Cartas_normales/G_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.green_mult
			bandera_colores_mult = true
		
		$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", Color("#214336"))
		
		if true and bandera_de_menus_movedisos:
			var diferencia = Vector2(14, 40)
			
			var pos = get_global_mouse_position()
			var dentro_x
			
			if $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x == 241:
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x - diferencia.x -10 and pos.x < $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +10
			else:
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x - diferencia.x -10 and pos.x < $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +10
			
			var dentro_y = pos.y > $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				diferencia = Vector2(14, 24)
				pos = get_global_mouse_position()
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x - diferencia.x -4 and pos.x < $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +4
				dentro_y = pos.y > $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.y - diferencia.y +5 and pos.y < $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.global_position.y + diferencia.y -5
				dentro = dentro_x and dentro_y
				
				if dentro:
					if !Global.bandera_mouse:
						if Input.is_action_just_pressed("click"):
							$Viewport/Baraja.last_hovered_card = null
							$Viewport/Baraja.arrastrado = null
							$Viewport/Baraja.dragging = null
							
							$Viewport/Zona_de_specials/Baraja_S.last_hovered_card = null
							$Viewport/Zona_de_specials/Baraja_S.arrastrado = null
							$Viewport/Zona_de_specials/Baraja_S.dragging = null
							if !(get_node_or_null("TweenMoverSpecials") and get_node_or_null("TweenMoverSpecials").is_active()):
								if baraja_activa == "baraja":
									baraja_activa = "baraja_amuletos"
									mover_specials_tienda_suave(397.857, 2)
									
									shake_specials("der")
								
								elif baraja_activa == "baraja_amuletos":
									baraja_activa = "baraja"
									mover_specials_tienda_suave(659.857, 2)
									
									shake_specials("izq")
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_amuletos":
							$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", Color("#179065"))
							Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
					if $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x < 257:
						$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x += 1
			else:
				if $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x > 241:
					$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x -= 1
	
	
	
	$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", Color("#214336"))
	
	var menu = get_node("Viewport/Menu")
	
	if estacion_actual == "nivel" and (baraja_activa == "baraja" or baraja_activa == "baraja_especial") and !bandera_para_botones and !Ejecutador.ejecutando:
		var numero = int($Viewport/Zona_de_cosas/Points_A.text)
		if numero >= puntos_por_nivel(nivel_actual) and !bandera_nivel:
			pasar_level()
		
		if true and bandera_de_menus_movedisos:
			var diferencia = Vector2(40, 24)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > $Viewport/Zona_de_specials/Specials1.global_position.x - diferencia.x and pos.x < $Viewport/Zona_de_specials/Specials1.global_position.x + diferencia.x
			var dentro_y = pos.y > $Viewport/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_specials/Specials1.global_position.y + diferencia.y -10
			var dentro = dentro_x and dentro_y
			
			if dentro:
				diferencia = Vector2(14, 24)
				pos = get_global_mouse_position()
				dentro_x = pos.x > $Viewport/Zona_de_specials/Specials1.global_position.x - diferencia.x -4 and pos.x < $Viewport/Zona_de_specials/Specials1.global_position.x + diferencia.x +4
				dentro_y = pos.y > $Viewport/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_specials/Specials1.global_position.y + diferencia.y -10
				dentro = dentro_x and dentro_y
				
				if dentro:
					if !Global.bandera_mouse:
						if Input.is_action_just_pressed("click"):
							$Viewport/Baraja.last_hovered_card = null
							$Viewport/Baraja.arrastrado = null
							$Viewport/Baraja.dragging = null
							
							$Viewport/Zona_de_specials/Baraja_S.last_hovered_card = null
							$Viewport/Zona_de_specials/Baraja_S.arrastrado = null
							$Viewport/Zona_de_specials/Baraja_S.dragging = null
							if !(get_node_or_null("TweenMoverSpecials") and get_node_or_null("TweenMoverSpecials").is_active()):
								if baraja_activa == "baraja":
									baraja_activa = "baraja_especial"
									for i in get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
										if !i.get_node("Sprite-top").visible:
											i.get_node("Sprite").visible = true
											i.visible = true
									
									mover_specials_suave(84.448)
									
									shake_specials("arriba")
								
								elif baraja_activa == "baraja_especial":
									baraja_activa = "baraja"
									mover_specials_suave(199)
									
									shake_specials("abajo")
						
						$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", Color("#179065"))
						Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
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
				"Delete": Vector2(20, 10),
				"Draw":   Vector2(20, 10),
				"Deck":   Vector2(20, 10)
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				# aca pones lo que ya tenias para hover/click de cada boton
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					# acciones de click segun el nombre
					match boton.name:
						"Draw":
							boton.position = Vector2(227.143, 28+2)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -20)
							boton.get_node("Play_sprites/Shaw").visible = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.3)
						"Deck":
							boton.position = Vector2(227.143, 81+2)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -20)
							boton.get_node("Play_sprites/Shaw").visible = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.3)
						"Delete":
							if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
								if !$Viewport/Baraja.dragging:
									boton.position = Vector2(227.143, 54+2)
								#boton.get_node("Play_sprites/Shaw").visible = false
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
								boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -20)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						
						if boton.name == "Draw":
							if baraja_activa == "baraja":
								$Viewport/Baraja.draw_cards(Global.stats.max_cards_in_hand)
						
						if boton.name == "Deck":
							if baraja_activa == "baraja":
								baraja_origen = "baraja"
								menu_actual = "Cartas_normales"
							
							elif baraja_activa == "baraja_especial":
								baraja_origen = "baraja_especial"
								menu_actual = "Cartas_Specials"
							
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
						"Draw":
							boton.position = Vector2(227.143, 28)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
							boton.get_node("Play_sprites/Shaw").visible = true
						"Deck":
							boton.position = Vector2(227.143, 81)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
							boton.get_node("Play_sprites/Shaw").visible = true
						"Delete":
							boton.position = Vector2(227.143, 54)
							if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
								boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
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
					"Draw":
						boton.position = Vector2(227.143, 28)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
						boton.get_node("Play_sprites/Shaw").visible = true
					"Deck":
						boton.position = Vector2(227.143, 81)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
						boton.get_node("Play_sprites/Shaw").visible = true
					"Delete":
						boton.position = Vector2(227.143, 54)
						if !boton.get_node("Play_sprites/AnimationPlayer").is_playing() and anim_agrandarse_played == false:
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
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
		
		
		menu = get_node("Viewport/Zona_de_interfaz/Nivel/1")
		
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "fondo" or boton.name == "Zona_de_cosas":
				continue
			
			var diffs = {
				"Play":    Vector2(20, 10),
			}
			
			if !(get_node("Viewport/Zona_de_interfaz/Nivel/1/Play").global_position.y < -125 and get_node("Viewport/Zona_de_interfaz/Nivel/1/Play").global_position.y > -135):
				continue
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				# aca pones lo que ya tenias para hover/click de cada boton
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"Play":
							if !Ejecutador.ejecutando:
								boton.position = Vector2(-77.44, 50)
								boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -20)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "Play":
							var padre = []
							
							for s in get_node("Viewport/Baraja").get_children()+get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
								if (typeof(s.padre) == TYPE_INT and (s.padre == 1 or s.padre == 2)):
									padre.append(s)
									break
							
							if padre != [] and padre.size() == 1:
								if !Ejecutador.ejecutando:
									Ejecutador.ejecutar_jugada(padre[0])
									continue
								else:
									print("Se esta ejecutando algo.")
							else:
								if padre == []:
									print("no podes")
								else:
									print("HAY QUE PONERTE UN CURSERO O MIRA Y QUE ELIGAS EL PADRE QUE SE ILUMINEN O ALGO NO SE")
									print("TIPO QUE SE PONGA TODO OBSCURO MENOS LOS PADRES HASTA LOS MENUS OBSCUROS")
							
							#cambiar_estacion()
					
					# reset valores segun boton
					match boton.name:
						"Play":
							boton.position = Vector2(-77.44, 48)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"Play":
						boton.position = Vector2(-77.44, 48)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(-40, -16)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false
	
	
	
	if estacion_actual == "seleccion_nivel" and !bandera_go_seleccion:
		menu = get_node("Viewport/Zona_de_interfaz/Select/Menu/1")
		
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "fondo":
				continue
			
			var diffs = {
				"GO":    Vector2(35, 20),
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x-2 and pos.x < boton.global_position.x + diferencia.x-2
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
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
							shake_go()
							bandera_go_seleccion = true
							bandera_para_botones = false
					
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
	
	#print(baraja_activa)
	if estacion_actual == "tienda":
		$Viewport/Zona_de_tienda/Menu/Reroll_Normal/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_normals), Global.prefix_plata]
		$Viewport/Zona_de_tienda/Menu/Reroll_Specials/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_specials), Global.prefix_plata]
		$Viewport/Zona_de_tienda/Menu/Reroll_Charms/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_amuletos), Global.prefix_plata]
	
	
	if estacion_actual == "tienda" and !bandera_go_tienda and baraja_activa != "usando_amuleto":
		if true and bandera_de_menus_movedisos:
			var diferencia = Vector2(40, 24)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.x - diferencia.x and pos.x < $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.x + diferencia.x
			var dentro_y = pos.y > $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.y + diferencia.y -10
			var dentro = dentro_x and dentro_y
			
			if dentro:
				diferencia = Vector2(14, 24)
				pos = get_global_mouse_position()
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.x - diferencia.x -4 and pos.x < $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.x + diferencia.x +4
				dentro_y = pos.y > $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.global_position.y + diferencia.y -10
				dentro = dentro_x and dentro_y
				
				if dentro:
					if !Global.bandera_mouse:
						if Input.is_action_just_pressed("click"):
							if !(get_node_or_null("TweenMoverSpecials") and get_node_or_null("TweenMoverSpecials").is_active()):
								if baraja_activa == "baraja":
									baraja_activa = "baraja_especial"
									for i in get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S").get_children():
										if !i.get_node("Sprite-top").visible:
											i.get_node("Sprite").visible = true
											i.visible = true
									
									mover_specials_tienda_suave(64.448)
									
									shake_specials("arriba")
								
								elif baraja_activa == "baraja_especial":
									baraja_activa = "baraja"
									mover_specials_tienda_suave(199)
									
									shake_specials("abajo")
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_especial":
							$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color", Color("#179065"))
							Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
					if $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y > -59:
						$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y -= 1
			else:
				if $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y < -43:
					$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y += 1
		
		$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", Color("#214336"))
		
		if true and bandera_de_menus_movedisos:
			var diferencia = Vector2(14, 40)
			
			var pos = get_global_mouse_position()
			var dentro_x
			
			if $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.position.x == 241:
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x - diferencia.x +15 and pos.x < $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +10
			else:
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x - diferencia.x - 5 and pos.x < $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +10
			
			var dentro_y = pos.y > $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.y - diferencia.y and pos.y < $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				diferencia = Vector2(14, 24)
				pos = get_global_mouse_position()
				dentro_x = pos.x > $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x - diferencia.x -4 and pos.x < $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.x + diferencia.x +4
				dentro_y = pos.y > $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.y - diferencia.y +5 and pos.y < $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.global_position.y + diferencia.y -5
				dentro = dentro_x and dentro_y
				
				if dentro:
					if !Global.bandera_mouse:
						if Input.is_action_just_pressed("click"):
							if !(get_node_or_null("TweenMoverSpecials") and get_node_or_null("TweenMoverSpecials").is_active()):
								if baraja_activa == "baraja":
									baraja_activa = "baraja_amuletos"
									mover_specials_tienda_suave(-242, 1)
									
									shake_specials("der")
								
								elif baraja_activa == "baraja_amuletos":
									baraja_activa = "baraja"
									mover_specials_tienda_suave(-514, 1)
									
									shake_specials("izq")
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_amuletos":
							$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", Color("#179065"))
							Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
					if $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.position.x < 257:
						$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.position.x += 1
			else:
				if $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.position.x > 241:
					$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.position.x -= 1
		
		
		menu = get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1")
		
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "fondo":
				continue
			
			var diffs = {
				"GO1":    Vector2(35, 20),
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x-2 and pos.x < boton.global_position.x + diferencia.x-2
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				# aca pones lo que ya tenias para hover/click de cada boton
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"GO1":
							boton.position = Vector2(-19.8+0.8, -11.25+0.8)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "GO1":
							baraja_activa = "baraja"
							cambiar_estacion()
							shake_go()
							bandera_go_tienda = true
					
					# reset valores segun boton
					match boton.name:
						"GO1":
							boton.position = Vector2(-19.8, -11.25)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"GO1":
						boton.position = Vector2(-19.8, -11.25)
						boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false
		
		var grid = $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
		var s_tenidos = $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S
		
		menu = get_node("Viewport/Zona_de_tienda/Menu")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible:
				continue
			
			# diferencias por nombre
			var diffs = {
				"Buy": [Vector2(40, 40), Vector2(5, -5)],
				"Reroll_Normal": [Vector2(12, 12), Vector2(5, -5)],
				"Reroll_Charms": [Vector2(12, 12), Vector2(5, -5)],
				"Reroll_Specials": [Vector2(12, 12), Vector2(5, -5)]
			}
			
			var diferencia = diffs[boton.name][0]
			
			#print($Viewport/Zona_de_tienda/Menu/Reroll_Specials.global_position)
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x + 5 and pos.x < boton.global_position.x + diferencia.x + 5
			var dentro_y = pos.y > boton.global_position.y - diferencia.y -5 and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				# aca pones lo que ya tenias para hover/click de cada boton
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					# acciones de click segun el nombre
					match boton.name:
						"Reroll_Specials":
							boton.position = Vector2(77, 144)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
						"Reroll_Normal":
							boton.position = Vector2(-47, 125)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
						"Reroll_Charms":
							boton.position = Vector2(370, 137)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
						"Buy":
							boton.position = Vector2(227.143, 54+3)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = false
							
							if $Viewport/Zona_de_tienda/Baraja_normales.dragging:
								domino_a_comprar = $Viewport/Zona_de_tienda/Baraja_normales.dragging
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
							
							elif $Viewport/Zona_de_tienda/Baraja_specials.dragging:
								domino_a_comprar = $Viewport/Zona_de_tienda/Baraja_specials.dragging
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
							
							elif $Viewport/Zona_de_tienda/Baraja_stamps.dragging:
								domino_a_comprar = $Viewport/Zona_de_tienda/Baraja_stamps.dragging
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
							
							elif grid.dragging:
								domino_a_comprar = grid.dragging
								domino_a_comprar.rect_scale = domino_a_comprar.rect_scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
							
							elif s_tenidos.dragging:
								domino_a_comprar = s_tenidos.dragging
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
								Global.usar_offset = false
								domino_a_comprar.scale_puede_cambiar = false
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						
						if boton.name == "Reroll_Normal":
							reroll("normal")
						elif boton.name == "Reroll_Charms":
							reroll("amuletos")
						elif boton.name == "Reroll_Specials":
							reroll("specials")
					
					# reset valores segun boton
					match boton.name:
						"Reroll_Specials":
							boton.position = Vector2(77, 142)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
							boton.get_node("Costo").visible = true
							boton.get_node("Play_sprites/Shaw").visible = true
						"Reroll_Normal":
							boton.position = Vector2(-47, 123)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
							boton.get_node("Costo").visible = true
							boton.get_node("Play_sprites/Shaw").visible = true
						"Reroll_Charms":
							boton.position = Vector2(370, 135)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
							boton.get_node("Costo").visible = true
							boton.get_node("Play_sprites/Shaw").visible = true
						"Buy":
							boton.position = Vector2(227.143, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 3)
							boton.get_node("Play_sprites/Shaw").visible = true
							
							if domino_a_comprar:
								if domino_a_comprar.get_parent().name == "Baraja_normales":
									if plata >= int(Global.stats["cost_normal_domino"].strip_edges().replace("<#b1911a>", "")):
										plata -= int(Global.stats["cost_normal_domino"].strip_edges().replace("<#b1911a>", ""))
										
										$Viewport/Zona_de_tienda/Baraja_normales.last_hovered_card = null
										$Viewport/Zona_de_tienda/Baraja_normales.arrastrado = null
										$Viewport/Zona_de_tienda/Baraja_normales.dragging = null
										
										var nuevo_nombre = domino_a_comprar.name
										
										if Global.dominos.has(domino_a_comprar.name):
											var nombres_existentes = []
											for carta in $Viewport/Baraja.mazo_original.keys():
												nombres_existentes.append(carta)
											
											while nuevo_nombre in nombres_existentes:
												nuevo_nombre += "t"
										
										
										# agregar al mazo
										$Viewport/Baraja.mazo_original[nuevo_nombre] = domino_a_comprar.yo
										
										$Viewport/Menu_info/Cartas_normales/Rojo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
										$Viewport/Menu_info/Cartas_normales/Azul.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
										$Viewport/Menu_info/Cartas_normales/Verde.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
										$Viewport/Menu_info/Cartas_normales/Amarillo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
										
										domino_a_comprar.queue_free()
										Global.usar_offset = true
										domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "Baraja_specials":
									if plata >= int(Global.dominos_especiales[domino_a_comprar.name]["plata"].strip_edges().replace("<#b1911a>", "")) and $Viewport/Zona_de_specials/Baraja_S.mazo_original.keys().size() < Global.stats.max_specials_cards_in_hand:
										plata -= int(Global.dominos_especiales[domino_a_comprar.name]["plata"].strip_edges().replace("<#b1911a>", ""))
										
										$Viewport/Zona_de_tienda/Baraja_specials.last_hovered_card = null
										$Viewport/Zona_de_tienda/Baraja_specials.arrastrado = null
										$Viewport/Zona_de_tienda/Baraja_specials.dragging = null
										
										var nuevo_nombre = domino_a_comprar.name
										
										if Global.dominos_especiales.has(domino_a_comprar.name):
											var nombres_existentes = []
											for carta in $Viewport/Zona_de_specials/Baraja_S.mazo_original.keys():
												nombres_existentes.append(carta)
											
											while nuevo_nombre in nombres_existentes:
												nuevo_nombre += "t"
										
										$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_original[nuevo_nombre] = domino_a_comprar.yo
										$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_original.duplicate()
										
										crear_special_tienda(nuevo_nombre)
										
										$Viewport/Zona_de_specials/Baraja_S.mazo_original[nuevo_nombre] = domino_a_comprar.yo
										
										domino_a_comprar.queue_free()
										Global.usar_offset = true
										domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "Baraja_stamps":
									if plata >= int(Global.stamps[domino_a_comprar.name]["plata"].strip_edges().replace("<#b1911a>", "")):
										plata -= int(Global.stamps[domino_a_comprar.name]["plata"].strip_edges().replace("<#b1911a>", ""))
										
										$Viewport/Zona_de_tienda/Baraja_stamps.last_hovered_card = null
										$Viewport/Zona_de_tienda/Baraja_stamps.arrastrado = null
										$Viewport/Zona_de_tienda/Baraja_stamps.dragging = null
										
										#insertar_stamp_a_domino(domino_a_comprar.name)
										
										if !Global.stamps[domino_a_comprar.name]["usable"]:
											amuletos_tenidos.append(domino_a_comprar.name)
											
											crear_amuleto(domino_a_comprar.name)
										else:
											usar_amuleto(domino_a_comprar.name)
										
										domino_a_comprar.queue_free()
										Global.usar_offset = true
										domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "GridContainer":
									plata += int(Global.stamps[domino_a_comprar.name]["venta"].strip_edges().replace("<#b1911a>", ""))
									
									grid.last_hovered_card = null
									grid.arrastrado = null
									grid.dragging = null
									
									#insertar_stamp_a_domino(domino_a_comprar.name)
									
									$Viewport/Zona_de_tienda/Baraja_stamps.mazo_original[domino_a_comprar.name] = (Diccionarios.amuletos[domino_a_comprar.name])
									$Viewport/Zona_de_tienda/Baraja_stamps.mazo_actual = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.duplicate()
									
									amuletos_tenidos.erase(domino_a_comprar.name)
									
									$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer.get_node(domino_a_comprar.name).free()
									domino_a_comprar.queue_free()
									Global.usar_offset = true
									domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "Baraja_S":
									plata += int(Global.dominos_especiales[domino_a_comprar.name]["venta"].strip_edges().replace("<#b1911a>", ""))
									
									s_tenidos.last_hovered_card = null
									s_tenidos.arrastrado = null
									s_tenidos.dragging = null
									
									#insertar_stamp_a_domino(domino_a_comprar.name)
									
									$Viewport/Zona_de_tienda/Baraja_specials.mazo_original[domino_a_comprar.name] = (Diccionarios.dominos_especiales[domino_a_comprar.name])
									$Viewport/Zona_de_tienda/Baraja_specials.mazo_actual = $Viewport/Zona_de_tienda/Baraja_specials.mazo_original.duplicate()
									
									$Viewport/Zona_de_specials/Baraja_S.mazo_original.erase(domino_a_comprar.name)
									$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
									
									domino_a_comprar.queue_free()
									Global.usar_offset = true
									domino_a_comprar = null
								
								
								get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
								
								shake_reroll()
								get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
					
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites/Sprite").use_parent_material = false
				match boton.name:
					"Reroll_Specials":
						boton.position = Vector2(77, 142)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
						boton.get_node("Costo").visible = false
						boton.get_node("Play_sprites/Shaw").visible = true
					"Reroll_Normal":
						boton.position = Vector2(-47, 123)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
						boton.get_node("Costo").visible = false
						boton.get_node("Play_sprites/Shaw").visible = true
					"Reroll_Charms":
						boton.position = Vector2(370, 135)
						boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
						boton.get_node("Costo").visible = false
						boton.get_node("Play_sprites/Shaw").visible = true
					"Buy":
						boton.position = Vector2(227.143, 54)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 3)
						boton.get_node("Play_sprites/Shaw").visible = true
						
						if domino_a_comprar:
							if domino_a_comprar.has_method("get_rect"):
								# Es un Control o similar
								domino_a_comprar.rect_scale = domino_a_comprar.rect_scale.linear_interpolate(Vector2(1, 1), 0.1)
							else:
								# Es un Node2D o Sprite
								domino_a_comprar.scale = domino_a_comprar.scale.linear_interpolate(Vector2(1, 1), 0.1)
							
							Global.usar_offset = true
							domino_a_comprar.scale_puede_cambiar = true
							anim_agrandarse_played = false
							domino_a_comprar = null


func cambiar_estacion() -> void:
	for i in get_tree().get_nodes_in_group("label_nueva"):
		i.free()
	cashout.clear()
	$Viewport/Cashout/Cashout.rect_size.y = 75
	
	var proxima_estacion = null
	match estacion_actual:
		"seleccion_nivel":
			proxima_estacion = "nivel"
		"tienda":
			proxima_estacion = "seleccion_nivel"
		"nivel":
			proxima_estacion = "tienda"
	
	bandera_de_menus_movedisos = false
	
	desaparecer(estaciones[proxima_estacion])


func desaparecer(destino: float) -> void:
	baraja_activa = "asd"
	
	for s in get_node("Viewport/Baraja").get_children():
		if !s.get_node("Sprite").visible:
			s.visible = false
	
	for s in get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
		if !s.get_node("Sprite").visible:
			s.visible = false
	
	if $Viewport/Zona_de_tienda/Baraja_stamps.dragging != null:
		$Viewport/Zona_de_tienda/Baraja_stamps.dragging.free()
	if $Viewport/Zona_de_tienda/Baraja_specials.dragging != null:
		$Viewport/Zona_de_tienda/Baraja_specials.dragging.free()
	if $Viewport/Zona_de_tienda/Baraja_normales.dragging != null:
		$Viewport/Zona_de_tienda/Baraja_normales.dragging.free()
	
	
	$Viewport/Zona_de_tienda/Baraja_normales.last_hovered_card = null
	$Viewport/Zona_de_tienda/Baraja_specials.last_hovered_card = null
	$Viewport/Zona_de_tienda/Baraja_stamps.last_hovered_card = null
	$Viewport/Zona_de_tienda/Baraja_normales.arrastrado = null
	$Viewport/Zona_de_tienda/Baraja_specials.arrastrado = null
	$Viewport/Zona_de_tienda/Baraja_stamps.arrastrado = null
	$Viewport/Zona_de_tienda/Baraja_normales.dragging = null
	$Viewport/Zona_de_tienda/Baraja_specials.dragging = null
	$Viewport/Zona_de_tienda/Baraja_stamps.dragging = null
	
	if $Viewport/Baraja.dragging != null:
		$Viewport/Baraja.dragging.free()
	if $Viewport/Baraja.arrastrado != null:
		$Viewport/Baraja.arrastrado.free()
	
	$Viewport/Baraja.last_hovered_card = null
	$Viewport/Baraja.arrastrado = null
	$Viewport/Baraja.dragging = null
	
	if $Viewport/Zona_de_specials/Baraja_S.dragging != null:
		$Viewport/Zona_de_specials/Baraja_S.dragging.free()
	if $Viewport/Zona_de_specials/Baraja_S.arrastrado != null:
		$Viewport/Zona_de_specials/Baraja_S.arrastrado.free()
	
	$Viewport/Zona_de_specials/Baraja_S.last_hovered_card = null
	$Viewport/Zona_de_specials/Baraja_S.arrastrado = null
	$Viewport/Zona_de_specials/Baraja_S.dragging = null
	
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
		$Viewport/Zona_de_interfaz/Nivel, "position:y", $Viewport/Zona_de_interfaz/Nivel.position.y, -50,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_interfaz/O_mult, "rect_position:x", $Viewport/Zona_de_interfaz/O_mult.rect_position.x, -170,
		0.7, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_botones, "rect_position:x", $Viewport/Zona_de_botones.rect_position.x, 306,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_interfaz/fondo, "position:x", $Viewport/Zona_de_interfaz/fondo.position.x, -1174.14,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/2"), "position:x", get_node("Viewport/Zona_de_interfaz/2").position.x, -1174.143,
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
		get_node("Viewport/Zona_de_specials").position.y, 240,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials"), "position:y",
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials").position.y, 240,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos"), "rect_position:x",
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos").rect_position.x, -544,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos"), "rect_position:x",
		get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos").rect_position.x, 707.857,
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
		$Viewport/Zona_de_interfaz/Nivel, "position:y", $Viewport/Zona_de_interfaz/Nivel.position.y, 0,
		1, Tween.TRANS_BACK, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_botones, "rect_position:x", $Viewport/Zona_de_botones.rect_position.x, 203.143,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_interfaz/O_mult, "rect_position:x", $Viewport/Zona_de_interfaz/O_mult.rect_position.x, -25,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_interfaz/fondo, "position:x", $Viewport/Zona_de_interfaz/fondo.position.x, -870.14,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/2"), "position:x", get_node("Viewport/Zona_de_interfaz/2").position.x, -870.143,
		1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	
	_a = tween.interpolate_property(
		$Viewport/Zona_de_baraja, "rect_position:y", $Viewport/Zona_de_baraja.rect_position.y, 40,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		$Viewport/Zona_de_tienda, "position:y", $Viewport/Zona_de_tienda.position.y, 0,
		0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT
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
		0.7, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/Menu/1").position.x, 288,
		0.7, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Select/2"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Select/2").position.x, -144.562,
		0.6, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1"), "position:x",
		get_node("Viewport/Zona_de_interfaz/Tienda/Menu/1").position.x, 288,
		0.7, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_specials"), "position:y",
		get_node("Viewport/Zona_de_specials").position.y, 199,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials"), "position:y",
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials").position.y, 202.5,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos"), "rect_position:x",
		get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos").rect_position.x, -514,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	_a = tween.interpolate_property(
		get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos"), "rect_position:x",
		get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos").rect_position.x, 659.857,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	
	if not tween.is_connected("tween_all_completed", self, "_on_aparecer_completo"):
		_a = tween.connect("tween_all_completed", self, "_on_aparecer_completo", [estacion_actual])
	
	_a = tween.start()


func _on_desaparecer_completo(destino: float, estacion) -> void:
	if estacion == "seleccion_nivel":
		get_node("Viewport/Zona_de_cosas/Level/Num").bbcode_text = "[center]\n"+str(nivel_actual)+"\n[/center]"
		$Viewport/Zona_de_cosas/Points_M.bbcode_text = "[right][wave amp=50 freq=2]\n "+str(puntos_por_nivel(nivel_actual))+" \n[/wave][/right]"
		_set_puntos_temp(0)
	
	for i in $Viewport/Baraja.get_children():
		i.free()
	
	for i in $Viewport/Zona_de_specials/Baraja_S.get_children():
		i.free()
	
	for i in $Viewport/Zona_de_tienda/Baraja_normales.get_children():
		i.free()
	
	for i in $Viewport/Zona_de_tienda/Baraja_specials.get_children():
		i.free()
	
	for i in $Viewport/Zona_de_tienda/Baraja_stamps.get_children():
		i.free()
	
	_tween_to(destino)


func _on_aparecer_completo(estacion) -> void:
	if estacion == "nivel":
		_set_puntos_temp(0)
		
		$Viewport/Baraja.mazo_actual = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Baraja.draw_cards(Global.stats.max_cards_in_hand)
		
		$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
		$Viewport/Zona_de_specials/Baraja_S.draw_cards(Global.stats.max_specials_cards_in_hand)
		
		if bandera_nivel:
			bandera_nivel = false
	
	if estacion == "tienda":
		$Viewport/Zona_de_tienda/Baraja_normales.mazo_actual = $Viewport/Zona_de_tienda/Baraja_normales.mazo_original.duplicate()
		$Viewport/Zona_de_tienda/Baraja_normales.draw_cards(Global.stats.max_cards_normal_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.normales_pueden_tener_stamps)
		
		$Viewport/Zona_de_tienda/Baraja_specials.mazo_actual = $Viewport/Zona_de_tienda/Baraja_specials.mazo_original.duplicate()
		$Viewport/Zona_de_tienda/Baraja_specials.draw_cards(Global.stats.max_cards_specials_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.specials_pueden_tener_stamps)
		
		$Viewport/Zona_de_tienda/Baraja_stamps.mazo_actual = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.duplicate()
		$Viewport/Zona_de_tienda/Baraja_stamps.draw_stamps(Global.stats.max_stamps_in_store)
		
		bandera_colores_mult = false
	
	baraja_activa = "baraja"
	
	bandera_de_menus_movedisos = true


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
	get_node("Viewport/Zona_de_interfaz/Select/2/Money_level").bbcode_text = "[right][wave amp=50 freq=2]\n"+str(plata_por_nivel(nivel_actual))+Global.prefix_plata+"\n[/wave]"
	get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
	get_node("Viewport/1/1/Draws/Draws_num/Draws_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(draws_actuales)+"\n[/wave]"
	get_node("Viewport/1/1/Plays/Plays_num/Plays_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plays_actuales)+"\n[/wave]"
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


func recibir_plata(texto, plata_a_recibir):
	get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
	plata += plata_a_recibir
	
	cashout.append(texto+str(plata_a_recibir))


func pasar_level():
	if !bandera_nivel:
		
		bandera_go_seleccion = false
		bandera_go_tienda    = false
		
		bandera_para_botones = true
		
		recibir_plata("Level Completion: ", plata_por_nivel(nivel_actual))
		
		draws_actuales = Global.stats.draws
		plays_actuales = Global.stats.plays
		
		baraja_activa = "baraja"
		
		print("Ganaste!")
		
		for s in get_node("Viewport/Baraja").get_children():
			if !s.get_node("Sprite").visible:
				s.visible = false
		
		for s in get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
			if !s.get_node("Sprite").visible:
				s.visible = false
		
		nivel_actual += 1
		puntos_actuales = 0
		_puntos_temp = 0
		
		if $Viewport/Baraja.dragging != null:
			$Viewport/Baraja.dragging.free()
		if $Viewport/Baraja.arrastrado != null:
			$Viewport/Baraja.arrastrado.free()
		
		$Viewport/Baraja.last_hovered_card = null
		$Viewport/Baraja.arrastrado = null
		$Viewport/Baraja.dragging = null
		
		if $Viewport/Zona_de_specials/Baraja_S.dragging != null:
			$Viewport/Zona_de_specials/Baraja_S.dragging.free()
		if $Viewport/Zona_de_specials/Baraja_S.arrastrado != null:
			$Viewport/Zona_de_specials/Baraja_S.arrastrado.free()
		
		$Viewport/Zona_de_specials/Baraja_S.last_hovered_card = null
		$Viewport/Zona_de_specials/Baraja_S.arrastrado = null
		$Viewport/Zona_de_specials/Baraja_S.dragging = null
		
		anim_agrandarse_played = false
		Global.usar_offset = true
		
		
		if has_node("analisa"):
			get_node("analisa").queue_free()
		
		
		#cambiar_estacion()
		
		mostrar_cashout()
		
		actualizar_escenario_seleccion_nivel()
		
		bandera_nivel = true


var mult = 10


func mostrar_cashout():
	$Viewport/Cashout/Cashout.rect_size.y = 75+(cashout.size()*mult)
	
	$Viewport/Cashout/Cashout/Lineas_t.bbcode_text = "[center][wave amp=50 freq=2]\n"+cashout[0]+"\n[/wave]"
	
	for i in cashout.size()-1:
		var label_nueva = $Viewport/Cashout/Cashout/Lineas_t.duplicate()
		label_nueva.add_to_group("label_nueva")
		label_nueva.rect_position.y = $Viewport/Cashout/Cashout/Lineas_t.rect_position.y+(cashout.size()*mult)
		label_nueva.bbcode_text = "[center][wave amp=50 freq=2]\n"+cashout[i]+"\n[/wave]"
		$Viewport/Cashout/Cashout.add_child(label_nueva)
	
	var tween: Tween = get_node_or_null("TweenMoverCashout")
	if tween != null:
		tween.queue_free()
	tween = Tween.new()
	tween.name = "TweenMoverCashout"
	add_child(tween)
	
	var _a = tween.stop_all()
	
	_a = tween.interpolate_property(
		$Viewport/Zona_de_interfaz/Nivel, "position:y", $Viewport/Zona_de_interfaz/Nivel.position.y, -50,
		0.4, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
	)
	
	# Overshoot al entrar
	_a = tween.interpolate_property(
		$Viewport/Cashout, "position:y", $Viewport/Cashout.position.y, -160,
		0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	
	if not tween.is_connected("tween_all_completed", self, "ocultar_cashout"):
		_a = tween.connect("tween_all_completed", self, "ocultar_cashout")
	
	_a = tween.start()


func ocultar_cashout():
	if $Viewport/Baraja.dragging != null:
		$Viewport/Baraja.dragging.free()
	if $Viewport/Baraja.arrastrado != null:
		$Viewport/Baraja.arrastrado.free()
	
	$Viewport/Baraja.last_hovered_card = null
	$Viewport/Baraja.arrastrado = null
	$Viewport/Baraja.dragging = null
	
	if $Viewport/Zona_de_specials/Baraja_S.dragging != null:
		$Viewport/Zona_de_specials/Baraja_S.dragging.free()
	if $Viewport/Zona_de_specials/Baraja_S.arrastrado != null:
		$Viewport/Zona_de_specials/Baraja_S.arrastrado.free()
	
	$Viewport/Zona_de_specials/Baraja_S.last_hovered_card = null
	$Viewport/Zona_de_specials/Baraja_S.arrastrado = null
	$Viewport/Zona_de_specials/Baraja_S.dragging = null
	
	var tween: Tween = get_node_or_null("TweenMoverCashout")
	if tween != null:
		tween.queue_free()
	tween = Tween.new()
	tween.name = "TweenMoverCashout"
	add_child(tween)
	
	var _a = tween.stop_all()
	
	# Overshoot al entrar
	_a = tween.interpolate_property(
		$Viewport/Cashout, "position:y", $Viewport/Cashout.position.y, -232-(cashout.size()*mult),
		0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.6
	)
	
	if not tween.is_connected("tween_all_completed", self, "cambiar_estacion"):
		_a = tween.connect("tween_all_completed", self, "cambiar_estacion")
	
	_a = tween.start()


func mover_specials_suave(destino_y):
	var nodo = get_node("Viewport/Zona_de_specials")
	var inicio_y = nodo.position.y
	var duracion = 0.5
	var tiempo = 0.0
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# --- Easing tipo TRANS_BACK + EASE_OUT ---
		var s = 1.70158
		t -= 1
		var suavizado = (t * t * ((s + 1) * t + s) + 1)
		# ------------------------------------------
		
		nodo.position.y = lerp(inicio_y, destino_y, suavizado)
		
		var baraja_s = get_node("Viewport/Zona_de_specials/Baraja_S")
		var hijos = baraja_s.get_children()
		
		# --- Filtramos solo los que tengan Sprite invisible ---
		var invisibles = []
		for h in hijos:
			if !h.get_node("Sprite").visible:
				invisibles.append(h)
		
		# --- Ordenamos esa lista por X ---
		_ordenar_invisibles_por_arbol()
		
		# --- Reordenamos en el arbol ---
		for idx in range(invisibles.size()):
			baraja_s.move_child(invisibles[idx], idx)
		
		# --- Ahora setear posicion ---
		for i in invisibles:
			i.setear_posision_correcta()
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	nodo.position.y = destino_y


func _ordenar_invisibles_por_arbol():
	var baraja_s = get_node("Viewport/Zona_de_specials/Baraja_S")
	var hijos = baraja_s.get_children()
	
	# 1) Filtrar invisibles
	var invisibles = []
	for h in hijos:
		if !h.get_node("Sprite").visible:
			invisibles.append(h)
	
	var padre = []
	
	# 2) Encontrar el nodo mas padre
	for s in get_node("Viewport/Baraja").get_children()+get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
		if (typeof(s.padre) == TYPE_INT and (s.padre == 1 or s.padre == 2)):
			padre.append(s)
			break
	
	if padre != [] and padre.size() == 1:
		padre = padre[0]
	
	var root = padre
	
	# 3) Obtener descendencia en orden generacional
	var orden_correcto = baraja_s.get_all_descendants(root)
	
	# 4) Quedarnos solo con los invisibles en ese orden
	var invisibles_ordenados = []
	for n in orden_correcto:
		if n in invisibles:
			invisibles_ordenados.append(n)
	
	# 5) Reordenar en el arbol
	for i in range(invisibles_ordenados.size()):
		baraja_s.move_child(invisibles_ordenados[i], i)


func mover_specials_tienda_suave(destino_y, banderita = 0):
	var nodo = get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials")
	if banderita == 1:
		nodo = get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos")
	elif banderita == 2:
		nodo = get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos")
	
	var inicio_y
	
	if banderita:
		inicio_y = nodo.rect_position.x
	else:
		inicio_y = nodo.position.y
	
	var duracion = 0.5
	var tiempo = 0.0
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# --- Easing tipo TRANS_BACK + EASE_OUT ---
		var s = 1.70158
		t -= 1
		var suavizado = (t * t * ((s + 1) * t + s) + 1)
		# ------------------------------------------
		
		if banderita:
			nodo.rect_position.x = lerp(inicio_y, destino_y, suavizado)
		else:
			nodo.position.y = lerp(inicio_y, destino_y, suavizado)
		
		var baraja_s = get_node("Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S")
		var hijos = baraja_s.get_children()
		
		# --- Filtramos solo los que tengan Sprite invisible ---
		var invisibles = []
		for h in hijos:
			if !h.get_node("Sprite").visible:
				invisibles.append(h)
		
		# --- Reordenamos en el arbol ---
		for idx in range(invisibles.size()):
			baraja_s.move_child(invisibles[idx], idx)
		
		# --- Ahora setear posicion ---
		for i in invisibles:
			i.setear_posision_correcta()
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	if banderita:
		nodo.rect_position.x = destino_y
	else:
		nodo.position.y = destino_y


func shake_go():
	camara.get_node("Camera2D").zoom_wave(1, -0.01, 0.2)


func shake_specials(lugar):
	camara.get_node("Camera2D").shake_wave(1, 3, 0.4, lugar)


func insertar_stamp_a_domino(stamp_a_insertar):
	print(stamp_a_insertar)


func crear_amuleto(amuleto):
	var grid =  $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
	var grid1 = $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
	
	var data = Diccionarios.amuletos[amuleto]
	
	var s = amuletos_instancia.instance()
	s.name = amuleto
	s.get_node("Sprite").region_rect.position = data["position"]
	s.get_node("Sprite").region_rect.size = data["size"]
	#s.rect_global_position = Vector2(208, 0)
	
	s.set_meta("base_pos", s.get_node("Sprite").position)
	
	$Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.erase(amuleto)
	
	# Configurar labels
	var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
	var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
	var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
	
	for label in [titulo_label, desc_label, costo_label]:
		label.bbcode_enabled = true
	
	titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
	desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
	costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["venta"])) + "[color=#b1911a]" + Global.prefix_plata
	
	grid.add_child(s)
	s = s.duplicate()
	grid1.add_child(s)


func crear_special_tienda(nombre):
	print(nombre)
	var grid =  $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S
	$Viewport/Zona_de_tienda/Baraja_specials.mazo_original.erase(nombre)
	grid.draw_cards(1, nombre)


func reroll(cosa):
	match cosa:
		"amuletos":
			if plata >= int(Global.stats.reroll_amuletos):
				plata -= int(Global.stats.reroll_amuletos)
				
				if $Viewport/Zona_de_tienda/Baraja_stamps.dragging != null:
					$Viewport/Zona_de_tienda/Baraja_stamps.dragging.free()
				
				$Viewport/Zona_de_tienda/Baraja_stamps.last_hovered_card = null
				$Viewport/Zona_de_tienda/Baraja_stamps.arrastrado = null
				$Viewport/Zona_de_tienda/Baraja_stamps.dragging = null
				
				for i in $Viewport/Zona_de_tienda/Baraja_stamps.get_children():
					i.free()
				
				$Viewport/Zona_de_tienda/Baraja_stamps.mazo_actual = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.duplicate()
				
				$Viewport/Zona_de_tienda/Baraja_stamps.draw_stamps(Global.stats.max_stamps_in_store)
		"specials":
			if plata >= int(Global.stats.reroll_specials):
				plata -= int(Global.stats.reroll_specials)
				
				if $Viewport/Zona_de_tienda/Baraja_specials.dragging != null:
					$Viewport/Zona_de_tienda/Baraja_specials.dragging.free()
				
				
				$Viewport/Zona_de_tienda/Baraja_specials.last_hovered_card = null
				$Viewport/Zona_de_tienda/Baraja_specials.arrastrado = null
				$Viewport/Zona_de_tienda/Baraja_specials.dragging = null
				
				for i in $Viewport/Zona_de_tienda/Baraja_specials.get_children():
					i.free()
				
				$Viewport/Zona_de_tienda/Baraja_specials.mazo_actual = $Viewport/Zona_de_tienda/Baraja_specials.mazo_original.duplicate()
				
				$Viewport/Zona_de_tienda/Baraja_specials.draw_cards(Global.stats.max_cards_specials_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.specials_pueden_tener_stamps)
		"normal":
			if plata >= int(Global.stats.reroll_normals):
				plata -= int(Global.stats.reroll_normals)
				
				if $Viewport/Zona_de_tienda/Baraja_normales.dragging != null:
					$Viewport/Zona_de_tienda/Baraja_normales.dragging.free()
				
				$Viewport/Zona_de_tienda/Baraja_normales.last_hovered_card = null
				$Viewport/Zona_de_tienda/Baraja_normales.arrastrado = null
				$Viewport/Zona_de_tienda/Baraja_normales.dragging = null
				
				for i in $Viewport/Zona_de_tienda/Baraja_normales.get_children():
					i.free()
				
				$Viewport/Zona_de_tienda/Baraja_normales.mazo_actual = $Viewport/Zona_de_tienda/Baraja_normales.mazo_original.duplicate()
				
				$Viewport/Zona_de_tienda/Baraja_normales.draw_cards(Global.stats.max_cards_normal_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.normales_pueden_tener_stamps)
	
	get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
	get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
	shake_reroll()


func shake_reroll():
	camara.get_node("Camera2D").rot_wave(2, 1, 0.2)
	camara.get_node("Camera2D").zoom_wave(2, 0.01, 0.2)


var charm_shake_time := 0.0
var charm_shaking := 0
var charm_shake_speed := 25.0 # velocidad del "temblor"
var charm_shake_strength := 8.0 # grados de rotacion

var dissolve_speed := 1.0 # velocidad a la que sube dissolve_value
var dissolve_value := 0.0


func usar_amuleto(amuleto):
	baraja_activa = "usando_amuleto"
	var charm = get_node("Viewport/Open_charm")
	charm.scale = Vector2(1, 1)
	charm.rotation_degrees = 0
	charm.visible = true
	charm.get_node("tope/cuerpo").region_rect.position = Diccionarios.amuletos[amuleto]["position"] + Vector2(0, 6)
	
	amuleto_siendo_usado = amuleto
	
	# activar temblor
	charm_shake_time = 0.0
	charm_shaking = 1


func _on_animation_finished(anim_name):
	if anim_name == "Nueva Animación":
		_empezar_animacion_de_bajar()


func _empezar_animacion_de_bajar():
	var base = "Viewport/Open_charm/tope/"
	var cuerpo = get_node(base + "cuerpo")
	var godray = get_node(base + "godray")
	
	
	charm_shaking = 0
	var charm = get_node("Viewport/Open_charm")
	
	# onda senoidal → rotacion izquierda/derecha
	charm.rotation = 0
	
	# si queres que se detenga después de un tiempo:
	_aplicar_dissolve(1.0)
	
	shake_reroll()
	
	charm.scale = Vector2(1.1, 1.1)
	charm.rotation_degrees = -10
	yield(get_tree(), "idle_frame")
	charm.scale = Vector2(1.1, 1.1)
	charm.rotation_degrees = -30
	yield(get_tree(), "idle_frame")
	charm.scale = Vector2(1.1, 1.1)
	charm.rotation_degrees = -40
	yield(get_tree(), "idle_frame")
	charm.get_node("tope/Pixe").visible = true
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	charm.rotation_degrees = 0
	$Viewport/Open_charm/tope/seleccion.visible = true
	$Viewport/Open_charm/tope/Menu.visible = true
	godray.visible = false
	cuerpo.visible = false
	charm.get_node("tope/Pixe").visible = false
	
	invocar_cosas(amuleto_siendo_usado)
	amuleto_siendo_usado = ""


func invocar_cosas(amuleto):
	print(amuleto)
	
	match amuleto: #   PARA LOS QUE HACEN ALGO MUY ESPECIFICO
		"":
			pass
	
	match Diccionarios.amuletos[amuleto].tipo_domino:
		"normal":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps)
		"special":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Barajas_seleccion/specials.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps)
		"stamp":
			$Viewport/Open_charm/tope/seleccion/stamps.visible = true
			$Barajas_seleccion/stamps.draw_stamps(Diccionarios.amuletos[amuleto].cuantos)


func _aplicar_dissolve(valor):
	var base = "Viewport/Open_charm/tope/"
	var cuerpo = get_node(base + "cuerpo")
	var anim = get_node(base + "AnimatedSprite")
	
	if cuerpo.material:
		cuerpo.material.set_shader_param("dissolve_value", valor)
	if anim.material:
		anim.material.set_shader_param("dissolve_value", valor)
