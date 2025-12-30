extends Node2D


var botonHover =   {"Play"              : false,
					"Deck"              : false,
					"Draw"              : false,
					"GO"                : false,
					"GO1"               : false,
					"Skip"              : false,
					"Buy"               : false,
					"Reroll_Normal"     : false,
					"Reroll_Charms"     : false,
					"Reroll_Specials"   : false,
					"Delete"            : false,
					"Delete1"           : false,
					"Options"           : false,
					"Quit"              : false,
					"Discord"           : false,
}


var paleta_de_colores = {
	"normal" : {
		"BG" : "GameBG",
		"colores_speciales" : {
			"color1" : Color("#173226"), #  DE OSCURO A CLARO
			"color2" : Color("#214336"), #  DE OSCURO A CLARO
			"color3" : Color("#179065"), #  DE OSCURO A CLARO
		},
		"colores_go" : {
			"color1" : Color("#1f4835"), #  DE OSCURO A CLARO
		},
	},
	"tienda" : {
		"BG" : "TiendaBG",
		"colores_speciales" : {
			"color1" : Color("#362f16"), #  DE OSCURO A CLARO
			"color2" : Color("#cab26b"), #  DE OSCURO A CLARO
			"color3" : Color("#fff6bc"), #  DE OSCURO A CLARO
		},
		"colores_go" : {
			"color1" : Color("#635012"), #  DE OSCURO A CLARO
		},
	},
	"boss_azul" : {
		"BG" : "BlueBG",
		"colores_speciales" : {
			"color1" : Color("#342e68"), #  DE OSCURO A CLARO
			"color2" : Color("#5956e9"), #  DE OSCURO A CLARO
			"color3" : Color("#b4b2ff"), #  DE OSCURO A CLARO
		},
		"colores_go" : {
			"color1" : Color("#342e68"), #  DE OSCURO A CLARO
		},
	}
}


var color_actual = "normal"


var EFECTOS_TEMPORALES = []

var EFECTOS_TEMPORALES_AMULETOS = []

var amuletos_instancia = preload("res://Scenas/Amuletos_de_menu.tscn")
var Specials_tienda_tenidos = preload("res://Scenas/Specials_tienda_tenidos.tscn")

var bandera_rerrols_y_delete = true

var bandera_de_menus_movedisos = false

var bandera_colores_mult = false

onready var botonPosision =  {  "Play"                  : {"global_position" : Vector2(230, -129)},
								"Draw"                  : {"global_position" : get_node("Viewport/Menu/Draw").global_position},
								"Deck"                  : {"global_position" : get_node("Viewport/Menu/Deck").global_position},
								"Delete"                : {"global_position" : get_node("Viewport/Menu/Delete").global_position},
								"Delete1"               : {"global_position" : get_node("Viewport/Zona_de_tienda/Menu/Delete1").global_position + Vector2(-5.5, 1)},
								"GO"                    : {"global_position" : Vector2(-785.057007, 118)},
								"GO1"                   : {"global_position" : Vector2(1214.943115, 118)},
								"Skip"                  : {"global_position" : Vector2(1202, 109)},
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

var domino_a_borrar    = null
var domino_a_conseguir = null
var domino_a_comprar   = null

var semilla

var amuletos_tenidos = []

var puntos_actuales = 0

var estacion_aux

# en tu singleton Global.gd (o en este script arriba):
var cartas_dibujadas = {
	"Cartas_normales": false,
	"ALGO": false,
	"STATS": false
}



func _ready():
	Global.stats = Global.stats_base.duplicate()
	
	$Tutorial.visible = false
	
	$"Viewport/Camera2D/Black".visible = true
	
	Global.guardar_save("Partida", "Nivel_Maximo_actual", 1)
	
	if Global.continuar:
		nivel_actual =                                      Global.leer_save("Partida","Nivel")
		Global.guardar_save("Partida", "Nivel_Maximo_actual", nivel_actual)
		plata =                                             Global.leer_save("Partida","Money")
		$Viewport/Baraja.mazo_original =                    Global.leer_save("Partida","Mazo_actual_normal")
		$Viewport/Zona_de_specials/Baraja_S.mazo_original = Global.leer_save("Partida","Mazo_actual_especial")
		amuletos_tenidos =                                  Global.leer_save("Partida","Mazo_actual_amuletos")
		
		
		$Viewport/Menu_info/Cartas_normales/Rojo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Menu_info/Cartas_normales/Azul.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Menu_info/Cartas_normales/Verde.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Menu_info/Cartas_normales/Amarillo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
		
		
		$Viewport/Baraja.mazo_actual = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
		
		actualizar_amuletos()
	else:
		Global.guardar_save("Partida", "Nivel",                1)
		Global.guardar_save("Partida", "Money",                0)
		Global.guardar_save("General", "Partida_guardada",     true)
		Global.guardar_save("Partida", "Mazo_actual_normal",   Global.dominos.duplicate())
		Global.guardar_save("Partida", "Mazo_actual_especial", {})
		Global.guardar_save("Partida", "Mazo_actual_amuletos", [])
		Global.guardar_save("Partida", "Mazo_valores_amuletos",[])
		
		$Viewport/Baraja.mazo_actual = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
		
		actualizar_amuletos()
	
	
	var datos = obtener_nivel_sprite()
	
	var spr =  get_node("Viewport/Zona_de_interfaz/Select/1/Level")
	var spr1 = get_node("Viewport/Zona_de_cosas/Level")
	
	spr.region_rect.position = datos["position"]
	spr.region_rect.size = datos["size"]
	
	spr1.region_rect.position = datos["position"]
	spr1.region_rect.size = datos["size"]
	
	$"Viewport/Zona_de_interfaz/Select/2/Descripcion".bbcode_text = "[wave amp=50 freq=2]"+datos["descripcion"]+"[/wave]"
	
	var _s = get_node("Viewport/Open_charm/tope/AnimationPlayer").connect(
		"animation_finished",
		self,
		"_on_animation_finished"
	)
	
	randomize()
	semilla = randi()
	
	semilla = 10
	
	seed(semilla)
	print(semilla)
	estacion_aux = estacion_actual
	estacion_actual = "transicion"
	
	#seed(10)
	
	$Viewport/Menu_info_BG.visible = true
	get_node("Viewport/1").position.x = estaciones[estacion_aux]
	
	yield(get_tree().create_timer(1), "timeout") 
	
	if Global.tutorial:
		$Tutorial.reproducir_siguiente_tuto("1")
		$Tutorial.visible = true
		get_tree().paused = true


var rng := RandomNumberGenerator.new()
var rng1 := RandomNumberGenerator.new()


func actualizar_amuletos():
	var cont = 0
	var array_valores = Global.leer_save("Partida", "Mazo_valores_amuletos")
	
	for i in amuletos_tenidos:
		crear_amuleto(i, array_valores[cont])
		
		var amuleto_a_afectar = Diccionarios.amuletos[i]
		
		if amuleto_a_afectar.has("stat"):
			for k in range(amuleto_a_afectar.stat.size()):
				EFECTOS_TEMPORALES_AMULETOS.append([amuleto_a_afectar.accion[k], amuleto_a_afectar.stat[k], i, true])
			
			aplicar_efecto(i)
		
		draws_actuales = Global.stats.draws
		plays_actuales = Global.stats.plays
		
		cont += 1


func puntos_por_nivel(nivel: int) -> int:
	if nivel <= 0:
		return 0
	
	var base := 40
	var crecimiento := 1.42
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
	
	var base := 16
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


var puntos_max = 0


func sumar_puntos(puntos):
	#var label = get_node("Viewport/Zona_de_cosas/Points_A")
	var puntos_iniciales = _puntos_temp
	var puntos_finales = puntos_actuales + puntos
	var duracion = 0.2
	
	puntos_max = puntos_finales
	
	# sumamos puntos siempre
	puntos_actuales += puntos
	
	# Tween para numero progresivo
	var tween_val = Tween.new()
	tween_val.name = "analisa"
	add_child(tween_val)
	tween_val.interpolate_property(self, "_puntos_temp", puntos_iniciales, puntos_finales, duracion, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween_val.start()
	tween_val.connect("tween_all_completed", self, "_on_tween_boing", [tween_val])
	
	_boing_activo = true


func _on_tween_boing(a):
	a.queue_free()
	_boing_activo = false
	pass


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


var charm_shake_time := 0.0
var charm_shaking := 0
var charm_shake_speed := 25.0 # velocidad del "temblor"
var charm_shake_strength := 8.0 # grados de rotacion

var dissolve_speed := 0.03 # velocidad a la que sube dissolve_value
var dissolve_value := 0.0

var frames_espera = 20


onready var player = get_node("wind")


func actualizar_global_mult():
	var num_str = ""
	if !(str(Global.stats.global_mult).find(".") != -1):
		num_str += ".0"
	
	var cont = (str(Global.stats.global_mult)+num_str).length() - 3
	
	if cont == 0:
		$Viewport/Zona_de_interfaz/O_mult.rect_size.x = 48
		$Viewport/Zona_de_interfaz/O_mult/O_mult.rect_size.x = 52
		
		$Viewport/Zona_de_interfaz/O_mult.rect_position.x = -25
		#$Viewport/Zona_de_interfaz/O_mult/O_mult.rect_position.x = -2
	else:
		$Viewport/Zona_de_interfaz/O_mult.rect_size.x = 48 + (cont * 10)
		$Viewport/Zona_de_interfaz/O_mult/O_mult.rect_size.x = 52 + (cont * 10)
		
		$Viewport/Zona_de_interfaz/O_mult.rect_position.x = -25 - (cont * 5)
		#$Viewport/Zona_de_interfaz/O_mult/O_mult.rect_position.x = -2 - (cont * 5)
	
	$Viewport/Zona_de_interfaz/O_mult/AnimationPlayer.play("mover")
	$Viewport/Zona_de_interfaz/O_mult/mult.bbcode_text = "[wave amp=20 freq=3] %s [/wave]" %(str(Global.stats.global_mult)+num_str)


func _physics_process(_delta):
#	if player.playing:
#		Global.detener_suave(player)
	
	#$music.global_position = camara.global_position
	
	#print($"Viewport/Zona_de_cosas/>=</>=<".global_position)
	
	if Input.is_action_just_pressed("ui_cancel"):
		if baraja_activa != "esperar_un_cacho" and baraja_activa != "usando_amuleto":
			var drag_baraja = $Viewport/Baraja.dragging == null
			var drag_spec_drag = $Viewport/Zona_de_specials/Baraja_S.dragging == null
			
			var drag_normal = drag_spec_drag and drag_baraja
			
			
			var drag_tienda_norm = $Viewport/Zona_de_tienda/Baraja_normales.dragging == null
			var drag_tienda_spec = $Viewport/Zona_de_tienda/Baraja_specials.dragging == null
			var drag_tienda_stamp = $Viewport/Zona_de_tienda/Baraja_stamps.dragging == null
			
			var drag_tienda = drag_tienda_stamp and drag_tienda_spec and drag_tienda_norm
			
			if drag_normal and drag_tienda:
				if not(baraja_activa == "Deck" or baraja_activa == "Deck1"):
					if !Global.tutorial:
						$Viewport/Camera2D/Black.mostrarse()
						get_tree().paused = true
	
	Global.bandera_mouse = false
	
	if baraja_activa == "esperar_un_cacho":
		if frames_espera > 0:
			frames_espera -= 1
		else:
			salir_de_usable()
			baraja_activa = "baraja"
	else:
		frames_espera = 20
	
	if baraja_activa == "usando_amuleto":
		$Barajas_seleccion/stampa_mouse.global_position = get_global_mouse_position()
		
		if $Barajas_seleccion/stampa_a_colocar.visible == true:
			var boton = $Barajas_seleccion/stampa_a_colocar
			var diferencia = Vector2(24, 24)
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				$Barajas_seleccion/stampa_a_colocar/Descripcion.visible = true
			else:
				$Barajas_seleccion/stampa_a_colocar/Descripcion.visible = false
		
		
		var botones = get_node("Viewport/Open_charm/tope/seleccion").get_children()
		
		botones.append(get_node("Viewport/Open_charm/tope/Menu/1/Skip"))
		
		for boton in botones:
			if boton.name == "NEW" or boton.name == "Zona_de_stamps":
				continue
			
			var diferencia = Vector2(45, 50)
			
			var aux = boton
			
			if boton.name != "Skip":
				boton.self_modulate.a = 0.5
			else:
				boton = botonPosision[boton.name]
				diferencia = Vector2(40, 20)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = aux
			
			var dragging = $Barajas_seleccion/normals.dragging or $Barajas_seleccion/specials.dragging or $Barajas_seleccion/stamps.dragging
			
			if boton.name == "Skip":
				boton.position = Vector2(-19.8, -11.25)
				boton.get_node("Play_sprites/Shaw").visible = true
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.1)
				
				if dentro:
					Global.bandera_mouse = true
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.2)
					boton.get_node("Play_sprites/Sprite").use_parent_material = true
					
					if Input.is_action_pressed("click"):
						botonHover[boton.name] = true
						boton.position = Vector2(-18.8, -10.5)
						boton.get_node("Play_sprites/Shaw").visible = false
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
					else:
						if botonHover[boton.name]:
							salir_de_usable()
							Global.sonido_boton()
							botonHover[boton.name] = false
				else:
					botonHover[boton.name] = false
			else:
				if dragging:
					boton.self_modulate.a = 1.0
					
					# --- animación suave ---
					var t = sin(OS.get_ticks_msec() / 300.0)  # oscilación suave
					var ease1 = pow(1 - abs(t), 2)             # easing tipo back invertido
					
					# tamaño base
					var escala_base = 1.05
					var rotacion_base = deg2rad(2)
					
					# si está adentro → más fuerte
					if dentro and boton.visible:
						if $Barajas_seleccion/normals.dragging:
							domino_a_conseguir = $Barajas_seleccion/normals.dragging
						elif $Barajas_seleccion/specials.dragging:
							domino_a_conseguir = $Barajas_seleccion/specials.dragging
						elif $Barajas_seleccion/stamps.dragging:
							domino_a_conseguir = $Barajas_seleccion/stamps.dragging
						
						if domino_a_conseguir == null:
							continue
						
						Global.bandera_mouse = true
						escala_base = 1.02
						rotacion_base = deg2rad(5)
						
						domino_a_conseguir.scale = domino_a_conseguir.scale.linear_interpolate(Vector2(0.3, 0.3), 0.1)
						
						Global.usar_offset = false
						
						domino_a_conseguir.scale_puede_cambiar = false
					else:
						if domino_a_conseguir:
							Global.usar_offset = true
							domino_a_conseguir.scale_puede_cambiar = true
					
					
					# aplicar transformaciones suaves
					boton.scale = Vector2(1, 1).linear_interpolate(Vector2(escala_base, escala_base), ease1)
					var rot_objetivo = rotacion_base * t
					boton.rotation = lerp(boton.rotation, rot_objetivo, 0.1)
				else:
					if dentro and boton.visible:
						if domino_a_conseguir:
							var tipo = ""
							
							if domino_a_conseguir.get_parent() == $Barajas_seleccion/normals:
								$Barajas_seleccion/normals.last_hovered_card = null
								$Barajas_seleccion/normals.arrastrado = null
								$Barajas_seleccion/normals.dragging = null
								tipo = "normal"
							
							elif domino_a_conseguir.get_parent() == $Barajas_seleccion/specials:
								$Barajas_seleccion/specials.last_hovered_card = null
								$Barajas_seleccion/specials.arrastrado = null
								$Barajas_seleccion/specials.dragging = null
								tipo = "special"
							
							elif domino_a_conseguir.get_parent() == $Barajas_seleccion/stamps:
								$Barajas_seleccion/stamps.last_hovered_card = null
								$Barajas_seleccion/stamps.arrastrado = null
								$Barajas_seleccion/stamps.dragging = null
								tipo = "stamp"
							
							if amuleto_siendo_usado == "Inverted Pack":
								tipo = "borrar_color_entero"
							
							if amuleto_siendo_usado == "borrar":
								tipo = "borrar_domino"
							
							match tipo:
								"borrar_color_entero":
									
									var keys = $Viewport/Baraja.mazo_original.keys()
									
									for nombre in keys:
										if nombre.begins_with(domino_a_conseguir.nombre.split("_")[0] + "_"):
											$Viewport/Baraja.mazo_original.erase(nombre)
								
								"borrar_domino":
									$Viewport/Baraja.mazo_original.erase(domino_a_conseguir.nombre)
								
								"normal":
									var nuevo_nombre = domino_a_conseguir.name
									
									if Global.dominos.has(domino_a_conseguir.name):
										var nombres_existentes = []
										for carta in $Viewport/Baraja.mazo_original.keys():
											nombres_existentes.append(carta)
										
										while nuevo_nombre in nombres_existentes:
											nuevo_nombre += "t"
									
									
									# agregar al mazo
									$Viewport/Baraja.mazo_original[nuevo_nombre] = domino_a_conseguir.yo
									
									$Viewport/Menu_info/Cartas_normales/Rojo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
									$Viewport/Menu_info/Cartas_normales/Azul.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
									$Viewport/Menu_info/Cartas_normales/Verde.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
									$Viewport/Menu_info/Cartas_normales/Amarillo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
							
								"special":
									var nuevo_nombre = domino_a_conseguir.name
									
									if Global.dominos_especiales.has(domino_a_conseguir.name):
										var nombres_existentes = []
										for carta in $Viewport/Zona_de_specials/Baraja_S.mazo_original.keys():
											nombres_existentes.append(carta)
										
										while nuevo_nombre in nombres_existentes:
											nuevo_nombre += "t"
									
									$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_original[nuevo_nombre] = domino_a_conseguir.yo
									$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Baraja_S.mazo_original.duplicate()
									
									crear_special_tienda(nuevo_nombre)
									
									$Viewport/Zona_de_specials/Baraja_S.mazo_original[nuevo_nombre] = domino_a_conseguir.yo
							
								"stamp":
									colocar_stampa(domino_a_conseguir.name, Diccionarios.amuletos[amuleto_siendo_usado].tipo_domino_stamp)
							
							var texto = $Viewport/Open_charm/tope/seleccion/NEW.bbcode_text
							var partes = texto.split(" ")
							var ultimo = partes[partes.size() - 2]
							
							ultimo = int(ultimo)-1
							
							$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(ultimo) +" [/wave][/center]"
							
							domino_a_conseguir.free()
							Global.usar_offset = true
							
							shake_reroll("sonido_conseguir")
							
							
							domino_a_conseguir = null
							
							if int(ultimo) == 0:
								salir_de_usable((tipo == "stamp"))
					
					if not dragging and not Input.is_action_pressed("click") and !dentro:
						domino_a_conseguir = null
					
					# volver suave a la normalidad
					boton.scale = boton.scale.linear_interpolate(Vector2(1, 1), 0.15)
					boton.rotation = lerp(boton.rotation, 0.0, 0.1)
		
#		if Input.is_action_just_pressed("ui_cancel"):
#			salir_de_usable()
	else:
		$Barajas_seleccion/stampa_mouse.visible = false
		$Barajas_seleccion/stampa_a_colocar.visible = false
		$Barajas_seleccion/stampa_a_colocar.get_child(0).visible = false
	
	
	if charm_shaking == 1 or charm_shaking == 2:
		charm_shake_time += _delta
		
		# onda senoidal → rotacion izquierda/derecha
		# usa *deg2rad()* porque Godot 3 rota en radianes
		#get_node("Viewport/Open_charm").rotation = sin(charm_shake_time * charm_shake_speed) * deg2rad(charm_shake_strength)
		
		dissolve_value = min(1.0, dissolve_value + dissolve_speed)
		_aplicar_dissolve(dissolve_value)
		
		# si queres que se detenga después de un tiempo:
		if charm_shake_time >= 0.6 and charm_shaking == 1:
			get_node("Viewport/Open_charm/tope/AnimationPlayer").play("Nueva Animación")
			
			charm_shaking = 2
			#get_node("Viewport/Open_charm").rotation = 0
			dissolve_value = 1.0
			_aplicar_dissolve(1.0)
	
	
	camara.get_node("Camera2D/FPS/FPS").text = str(Engine.get_frames_per_second())
	
	if Input.is_action_pressed("subir_puntos") and estacion_actual == "nivel" and !bandera_nivel and (baraja_activa == "baraja" or baraja_activa == "baraja_especial"):
		sumar_puntos(5)
	
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
		var cont_otro = 0
		for s in get_node("Viewport/Baraja").get_children():
			if !s.get_node("Sprite").visible:
				cont += 1
			else:
				cont_otro += 1
		
		if cont_otro == 0:
			$Viewport/EMPTY.visible = true
		else:
			$Viewport/EMPTY.visible = false
		
		cont_otro = 0
		
		for s in get_node("Viewport/Zona_de_specials/Baraja_S").get_children():
			if !s.get_node("Sprite").visible:
				cont += 1
			else:
				cont_otro += 1
		
		if cont_otro == 0:
			$Viewport/Zona_de_specials/EMPTY.visible = true
		else:
			$Viewport/Zona_de_specials/EMPTY.visible = false
		
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
			$Viewport/GameBG.position = (((posision-$Viewport/GameBG.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = (((posision-nodo.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			
			get_node("Viewport/Cartelitos").position.x = estaciones[estacion_actual]
		else:
			camara.position = Vector2(estaciones[estacion_aux], 0)
			$Viewport/GameBG.position = Vector2(estaciones[estacion_aux], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = Vector2(estaciones[estacion_aux], 0)
			
			get_node("Viewport/Cartelitos").position.x = estaciones[estacion_actual]
	else:
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			$Viewport/GameBG.position = (((posision-$Viewport/GameBG.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = (((posision-nodo.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			
			get_node("Viewport/Cartelitos").position.x = estaciones[estacion_actual]
		else:
			camara.position = Vector2(estaciones[estacion_actual], 0)
			$Viewport/GameBG.position = Vector2(estaciones[estacion_actual], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = Vector2(estaciones[estacion_actual], 0)
			
			get_node("Viewport/Cartelitos").position.x = estaciones[estacion_actual]
	
	
	if baraja_activa == "Deck" or baraja_activa == "Deck1":
		if menu_actual == "Cartas_normales":
			if not cartas_dibujadas["Cartas_normales"]:
				cartas_dibujadas["Cartas_normales"] = true
				
				for i in $Viewport/Menu_info/Cartas_normales/Rojo.get_children():
					i.free()
				for i in $Viewport/Menu_info/Cartas_normales/Azul.get_children():
					i.free()
				for i in $Viewport/Menu_info/Cartas_normales/Verde.get_children():
					i.free()
				for i in $Viewport/Menu_info/Cartas_normales/Amarillo.get_children():
					i.free()
				
				$Viewport/Menu_info/Cartas_normales/Rojo.draw_cards("naranja")
				$Viewport/Menu_info/Cartas_normales/Azul.draw_cards("rosa")
				$Viewport/Menu_info/Cartas_normales/Verde.draw_cards("azul")
				$Viewport/Menu_info/Cartas_normales/Amarillo.draw_cards("verde")
		
		if menu_actual == "ALGO":
			if not cartas_dibujadas["ALGO"]:
				# aqui cuando tengas el draw de specials
				cartas_dibujadas["ALGO"] = true
		
		if menu_actual == "STATS":
			if not cartas_dibujadas["STATS"]:
				
				crear_stats()
				
				cartas_dibujadas["STATS"] = true
		
		
		if menu_actual == "Cartas_normales":
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = false
			
			$Viewport/Menu_info/Cartas_normales.visible = true
			$Viewport/Menu_info/ALGO.visible = false
			$Viewport/Menu_info/STATS.visible = false
		
		
		if menu_actual == "ALGO":
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = false
			
			$Viewport/Menu_info/ALGO.visible = true
			$Viewport/Menu_info/STATS.visible = false
			$Viewport/Menu_info/Cartas_normales.visible = false
		
		
		if menu_actual == "STATS":
			$"Viewport/Menu_info/Botones/COMBOS/Fondo".visible = true
			$"Viewport/Menu_info/Botones/Specials Dominos/Fondo".visible = false
			$"Viewport/Menu_info/Botones/Common Dominos/Fondo".visible = false
			
			$Viewport/Menu_info/STATS.visible = true
			$Viewport/Menu_info/ALGO.visible = false
			$Viewport/Menu_info/Cartas_normales.visible = false
		
		
		for boton in $"Viewport/Menu_info/Botones".get_children():
			var mouse_pos = get_global_mouse_position()
			var rect = Rect2(boton.get_node("Sombra").rect_global_position, boton.rect_size)
			
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
						Global.sonido_boton()
						menu_actual = "Cartas_normales"
					elif boton.name == "Specials Dominos":
						Global.sonido_boton()
						menu_actual = "ALGO"
					elif boton.name == "COMBOS":
						Global.sonido_boton()
						menu_actual = "STATS"
			else:
				boton.rect_position.y = -12
				boton.get_node("Sombra").rect_position.y = 2
				boton.material.set_shader_param("to_color", Color("#346c53"))
		
		
		if Input.is_action_just_pressed("ui_cancel"):
			cartas_dibujadas = {
				"Cartas_normales": false,
				"ALGO": false,
				"STATS": false
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
	
	
	if estacion_actual == "nivel" and !bandera_para_botones and !Ejecutador.ejecutando:
		if !bandera_colores_mult:
			$Viewport/Menu_info/Cartas_normales/O_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.orange_mult
			$Viewport/Menu_info/Cartas_normales/R_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.rose_mult
			$Viewport/Menu_info/Cartas_normales/A_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.blue_mult
			$Viewport/Menu_info/Cartas_normales/G_mult/mult.bbcode_text = "[wave amp=20 freq=3] %.1f [/wave]" % Global.stats.green_mult
			
			$Viewport/Menu_info/Cartas_normales/O_mult/chance.bbcode_text = "[wave amp=20 freq=3] %s [/wave]" % Global.stats["orange_%"]
			$Viewport/Menu_info/Cartas_normales/R_mult/chance.bbcode_text = "[wave amp=20 freq=3] %s [/wave]" % Global.stats["rose_%"]
			$Viewport/Menu_info/Cartas_normales/A_mult/chance.bbcode_text = "[wave amp=20 freq=3] %s [/wave]" % Global.stats["blue_%"]
			$Viewport/Menu_info/Cartas_normales/G_mult/chance.bbcode_text = "[wave amp=20 freq=3] %s [/wave]" % Global.stats["green_%"]
			bandera_colores_mult = true
		
		if Global.bg_tienda:
			$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color2)
		else:
			$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color2)
		
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
								
								Global.sonido_slash()
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_amuletos":
							if Global.bg_tienda:
								$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color3)
							else:
								$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color3)
							
							Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
					if $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x < 257:
						$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x += 1
			else:
				if $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x > 241:
					$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.position.x -= 1
	
	
	if Global.bg_tienda:
		$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color2)
	else:
		$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color2)
	
	var menu = get_node("Viewport/Menu")
	
	if estacion_actual == "nivel" and (baraja_activa == "baraja" or baraja_activa == "baraja_especial") and !bandera_para_botones and !Ejecutador.ejecutando:
		var numero = int($Viewport/Zona_de_cosas/Points_A.text)
		if numero >= puntos_por_nivel(nivel_actual) and !bandera_nivel and !_boing_activo:
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
								
								Global.sonido_slash()
						
						if Global.bg_tienda:
							$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color3)
						else:
							$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color3)
						
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
								var hijos_anteriores = $Viewport/Baraja.get_child_count()
								
								$Viewport/Baraja.draw_cards(Global.stats.max_cards_in_hand)
								
								if $Viewport/Baraja.get_child_count() == hijos_anteriores:
									$Viewport/Menu/Draw/Play_sprites/anim.play("denegar")
									shake_reroll("coin_cancel")
								else:
									#Global.reproducir_sonido("Comprar_vender_1", camara.global_position)
									Global.reproducir_sonido("Click", camara.global_position)
									shake_reroll()
						
						if boton.name == "Deck":
							if baraja_activa == "baraja":
								baraja_origen = "baraja"
								menu_actual = "Cartas_normales"
							
							elif baraja_activa == "baraja_especial":
								baraja_origen = "baraja_especial"
								menu_actual = "Cartas_normales"
							
							cartas_dibujadas[menu_actual] = false
							
							Global.sonido_boton()
							
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
								Global.sonido_boton()
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
							domino_a_borrar.scale = Vector2(1, 1)
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
									plays_actuales -= 1
									get_node("Viewport/1/1/Plays/Plays_num/Plays_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plays_actuales)+"\n[/wave]"
									get_node("Viewport/1/1/Plays/AnimationPlayer").play("mover")
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
	
	
	for nodo in paleta_de_colores:
		if nodo == "normal": continue
		
		if nodo == color_actual: continue
		
		nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
		
		if nodo.modulate.a8 > 0:
			var nuevo_color  = paleta_de_colores["normal"]["colores_speciales"].color1
			var nuevo_color1 = paleta_de_colores["normal"]["colores_go"].color1
			
			var mats = [
				$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1,
				$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1,
				$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1,
				$Viewport/Zona_de_specials/Specials1
			]
			
			var mats1 = [
				$"Viewport/1/1",
				$"Viewport/Zona_de_interfaz/Tienda/Menu/1/fondo",
			]
			
			var actual1 = mats1[0].material.get_shader_param("to_color")
			var mezclado1 = actual1.linear_interpolate(nuevo_color1, 0.1)
			mats1[0].material.set_shader_param("to_color", mezclado1)
			
			actual1 = mats1[1].material.get_shader_param("flash_color")
			mezclado1 = actual1.linear_interpolate(nuevo_color1, 0.1)
			mats1[1].material.set_shader_param("flash_color", mezclado1)
			
			for m in mats:
				var actual = m.material.get_shader_param("to_color1")
				var mezclado = actual.linear_interpolate(nuevo_color, 0.1)
				m.material.set_shader_param("to_color1", mezclado)
			
			nodo.modulate.a8 -= 10
		
		else:
			var nuevo_color  = paleta_de_colores["normal"]["colores_speciales"].color1
			var nuevo_color1 = paleta_de_colores["normal"]["colores_go"].color1
			
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
			$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
			$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
		
			$"Viewport/1/1".material.set_shader_param("to_color", nuevo_color1)
			$"Viewport/Zona_de_interfaz/Tienda/Menu/1/fondo".material.set_shader_param("flash_color", nuevo_color1)
	
	
	if !Global.bg_tienda:
		var nuevo_color  = paleta_de_colores["normal"]["colores_speciales"].color1
		var nuevo_color1 = paleta_de_colores["normal"]["colores_go"].color1
		
		$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
		$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
		$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
		$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
		
		$"Viewport/1/1".material.set_shader_param("to_color", nuevo_color1)
		$"Viewport/Zona_de_interfaz/Tienda/Menu/1/fondo".material.set_shader_param("flash_color", nuevo_color1)
	
	
	if estacion_actual == "seleccion_nivel" and !bandera_go_seleccion:
#		if Global.bg_tienda:
#			if $Viewport/Tiend1aBG.modulate.a8 > 0:
#				$Viewport/Tiend1aBG.modulate.a8 -= 10
		
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
	
	
	if Global.bg_tienda:
		var nodo = $Viewport.get_node(paleta_de_colores[color_actual].BG)
		
		if color_actual != "normal":
			if nodo.modulate.a8 < 256:
				var nuevo_color  = paleta_de_colores[color_actual]["colores_speciales"].color1
				var nuevo_color1 = paleta_de_colores[color_actual]["colores_go"].color1
				
				# Lista de materiales a cambiar
				var mats = [
					$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1,
					$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1,
					$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1,
					$Viewport/Zona_de_specials/Specials1
				]
				
				var mats1 = [
					$"Viewport/1/1",
					$"Viewport/Zona_de_interfaz/Tienda/Menu/1/fondo",
				]
				
				var actual1 = mats1[0].material.get_shader_param("to_color")
				var mezclado1 = actual1.linear_interpolate(nuevo_color1, 0.1)
				mats1[0].material.set_shader_param("to_color", mezclado1)
				
				actual1 = mats1[1].material.get_shader_param("flash_color")
				mezclado1 = actual1.linear_interpolate(nuevo_color1, 0.1)
				mats1[1].material.set_shader_param("flash_color", mezclado1)
				
				for m in mats:
					var actual = m.material.get_shader_param("to_color")
					var mezclado = actual.linear_interpolate(nuevo_color, 0.1) # 0.1 = velocidad
					m.material.set_shader_param("to_color1", mezclado)
				
				nodo.modulate.a8 += 10
			else:
				var nuevo_color  = paleta_de_colores[color_actual]["colores_speciales"].color1
				var nuevo_color1 = paleta_de_colores[color_actual]["colores_go"].color1
				
				$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
				$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
				$Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Specials1.material.set_shader_param("to_color1", nuevo_color)
				$Viewport/Zona_de_specials/Specials1.material.set_shader_param("to_color1", nuevo_color)
				
				$"Viewport/1/1".material.set_shader_param("to_color", nuevo_color1)
				$"Viewport/Zona_de_interfaz/Tienda/Menu/1/fondo".material.set_shader_param("flash_color", nuevo_color1)
	
	
	#print(baraja_activa)
	if estacion_actual == "tienda":
		
		
		draws_actuales = Global.stats.draws
		plays_actuales = Global.stats.plays
		
		get_node("Viewport/1/1/Draws/Draws_num/Draws_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(draws_actuales)+"\n[/wave]"
		get_node("Viewport/1/1/Plays/Plays_num/Plays_num").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plays_actuales)+"\n[/wave]"
		
		$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Cartas_Actuales.text = str(amuletos_tenidos.size())
		$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Cartas_Max.text      = str(Global.stats.max_amuletos)
		
		if bandera_rerrols_y_delete:
			color_actual = "tienda"
			
			$Viewport/Zona_de_tienda/Menu/Reroll_Normal/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_normals), Global.prefix_plata]
			$Viewport/Zona_de_tienda/Menu/Reroll_Specials/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_specials), Global.prefix_plata]
			$Viewport/Zona_de_tienda/Menu/Reroll_Charms/Costo/Label.bbcode_text = "[center][color=#b1911a]%s%s[/color][/center]" % [str(Global.stats.reroll_amuletos), Global.prefix_plata]
			$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(Global.stats.cantidad_de_borrables_por_tienda)]
			bandera_rerrols_y_delete = false
	
	if estacion_actual == "tienda" and !bandera_go_tienda and baraja_activa != "usando_amuleto":
		if Global.bg_tienda:
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color2)
		else:
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color2)
		
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
								
								Global.sonido_slash()
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_especial":
							if Global.bg_tienda:
								$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color3)
							else:
								$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color3)
							
							
							Global.bandera_mouse = true
				
				if (baraja_activa == "baraja"):
					if $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y > -59:
						$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y -= 1
			else:
				if $Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y < -38:
					$Viewport/Zona_de_interfaz/Tienda/Zona_de_specials/Specials1.position.y += 1
		
		if Global.bg_tienda:
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color2)
		else:
			$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color2)
		
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
								
								Global.sonido_slash()
						
						if (baraja_activa == "baraja") or baraja_activa == "baraja_amuletos":
							if Global.bg_tienda:
								$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores[color_actual]["colores_speciales"].color3)
							else:
								$Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Specials1.material.set_shader_param("to_color", paleta_de_colores["normal"]["colores_speciales"].color3)
							
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
				"Reroll_Specials": [Vector2(12, 12), Vector2(5, -5)],
				"Delete1": [Vector2(11, 11), Vector2(0, 0)],
			}
			
			var diferencia = diffs[boton.name][0]
			
			#print($Viewport/Zona_de_tienda/Menu/Reroll_Specials.global_position)
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x +5 and pos.x < boton.global_position.x + diferencia.x + 5
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
						"Delete1":
							boton.position = Vector2(234, -6)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 0)
							boton.get_node("Play_sprites/Shaw").visible = true
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
						elif boton.name == "Delete1":
							if baraja_activa == "baraja":
								usar_amuleto("borrar")
								
								if !cantidad_borrables_por_tienda <= 0:
									cantidad_borrables_por_tienda -= 1
									$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
					
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
						"Delete1":
							boton.position = Vector2(234, -8)
							boton.get_node("Play_sprites/Shaw").rect_position = Vector2(0, 5)
							boton.get_node("Costo").visible = true
							boton.get_node("Play_sprites/Shaw").visible = true
						"Buy":
							boton.position = Vector2(227.143, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 3)
							boton.get_node("Play_sprites/Shaw").visible = true
							
							if domino_a_comprar:
								var nombre_domino_a_comprar = domino_a_comprar.nombre
								
								if domino_a_comprar.get_parent().name == "Baraja_normales":
									var precio_str = Global.stats["cost_normal_domino"]
									var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
									
									var descuento = Global.stats["descuento"] / 100.0
									var precio_final = int(round(precio * (1.0 - descuento)))
									
									# volvemos a poner el tag
									var precio_bbcode = "<#b1911a>" + str(precio_final)
									
									if plata >= int(precio_bbcode.strip_edges().replace("<#b1911a>", "")):
										plata -= int(precio_bbcode.strip_edges().replace("<#b1911a>", ""))
										
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
									var precio_str = Global.dominos_especiales[domino_a_comprar.name]["plata"]
									var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
									
									var descuento = Global.stats["descuento"] / 100.0
									var precio_final = int(round(precio * (1.0 - descuento)))
									
									# volvemos a poner el tag
									var precio_bbcode = "<#b1911a>" + str(precio_final)
									
									if plata >= int(precio_bbcode.strip_edges().replace("<#b1911a>", "")) and $Viewport/Zona_de_specials/Baraja_S.mazo_original.keys().size() < Global.stats.max_specials_cards_in_hand:
										plata -= int(precio_bbcode.strip_edges().replace("<#b1911a>", ""))
										
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
									var precio_str = domino_a_comprar.get_parent().mazo_original[nombre_domino_a_comprar]["plata"]
									var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
									
									var descuento = Global.stats["descuento"] / 100.0
									var precio_final = int(round(precio * (1.0 - descuento)))
									
									var resta = 0
									
									if nombre_domino_a_comprar == "Crystal Shard": resta = 4
									
									# volvemos a poner el tag
									var precio_bbcode = "<#b1911a>" + str(precio_final)
									
									if domino_a_comprar.gratis:
										precio_bbcode = "<#b1911a>0"
									
									if plata >=  int(precio_bbcode.strip_edges().replace("<#b1911a>", "")) and amuletos_tenidos.size() < Global.stats.max_amuletos - resta:
										plata -= int(precio_bbcode.strip_edges().replace("<#b1911a>", ""))
										
										$Viewport/Zona_de_tienda/Baraja_stamps.last_hovered_card = null
										$Viewport/Zona_de_tienda/Baraja_stamps.arrastrado = null
										$Viewport/Zona_de_tienda/Baraja_stamps.dragging = null
										
										
										for k in range(0, amuletos_tenidos.size()):
											if amuletos_tenidos[k] != "Domino Mask": continue
											
											amuletos_tenidos[k] = nombre_domino_a_comprar
											
											var data = Diccionarios.amuletos[nombre_domino_a_comprar]
											
											var amuleto_nodo  = get_tree().root.get_node("Game/Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(k)
											var amuleto_nodo1 = amuleto_nodo.nodo_vinculado
											
											amuleto_nodo.nombre  = nombre_domino_a_comprar
											amuleto_nodo1.nombre = nombre_domino_a_comprar
											
											amuleto_nodo.get_node("Sprite").region_rect.position = data["position"]
											amuleto_nodo.get_node("Sprite").region_rect.size = data["size"]
											
											amuleto_nodo1.get_node("Sprite").region_rect.position = data["position"]
											amuleto_nodo1.get_node("Sprite").region_rect.size = data["size"]
											
											# Configurar labels
											var titulo_label = amuleto_nodo.get_node("Descripcion/MarginContainer/Titulo/Label")
											var desc_label   = amuleto_nodo.get_node("Descripcion/MarginContainer/Descripcion/Label")
											var costo_label  = amuleto_nodo.get_node_or_null("Descripcion/MarginContainer/Costo/Label")
											
											var titulo_label1 = amuleto_nodo1.get_node("Descripcion/MarginContainer/Titulo/Label")
											var desc_label1   = amuleto_nodo1.get_node("Descripcion/MarginContainer/Descripcion/Label")
											var costo_label1  = amuleto_nodo1.get_node_or_null("Descripcion/MarginContainer/Costo/Label")
											
											for label in [titulo_label, desc_label, costo_label]:
												if label: label.bbcode_enabled = true
											
											for label in [titulo_label1, desc_label1 , costo_label1]:
												if label: label.bbcode_enabled = true
											
											titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
											desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
											if costo_label: costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["venta"])) + "[color=#b1911a]" + Global.prefix_plata
											
											titulo_label1.bbcode_text = titulo_label.bbcode_text
											desc_label1.bbcode_text   = desc_label.bbcode_text
											if costo_label: costo_label1.bbcode_text  = costo_label.bbcode_text
											
											if Diccionarios.amuletos[nombre_domino_a_comprar].has("stat"):
												for j in range(Diccionarios.amuletos[nombre_domino_a_comprar].stat.size()):
													EFECTOS_TEMPORALES_AMULETOS.append([Diccionarios.amuletos[nombre_domino_a_comprar].accion[j], Diccionarios.amuletos[nombre_domino_a_comprar].stat[j], nombre_domino_a_comprar, true])
												
												aplicar_efecto(nombre_domino_a_comprar)
												
												if cantidad_borrables_por_tienda_max != Global.stats.cantidad_de_borrables_por_tienda:
													cantidad_borrables_por_tienda += Global.stats.cantidad_de_borrables_por_tienda-cantidad_borrables_por_tienda_max
													cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
													$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
										
										
										if !domino_a_comprar.get_parent().mazo_original[nombre_domino_a_comprar]["usable"]:
											amuletos_tenidos.append(nombre_domino_a_comprar)
											
											crear_amuleto(nombre_domino_a_comprar)
											
											var amuleto_a_afectar = domino_a_comprar.get_parent().mazo_original[nombre_domino_a_comprar]
											
											if amuleto_a_afectar.has("stat"):
												for k in range(amuleto_a_afectar.stat.size()):
													EFECTOS_TEMPORALES_AMULETOS.append([amuleto_a_afectar.accion[k], amuleto_a_afectar.stat[k], nombre_domino_a_comprar, true])
												
												aplicar_efecto(nombre_domino_a_comprar)
												
												if cantidad_borrables_por_tienda_max != Global.stats.cantidad_de_borrables_por_tienda:
													cantidad_borrables_por_tienda += Global.stats.cantidad_de_borrables_por_tienda-cantidad_borrables_por_tienda_max
													cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
													$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
										else:
											usar_amuleto(nombre_domino_a_comprar)
										
										domino_a_comprar.queue_free()
										Global.usar_offset = true
										domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "GridContainer":
									var precio_str = domino_a_comprar.get_parent().mazo_original[nombre_domino_a_comprar]["venta"]
									var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
									
									var descuento = Global.stats["descuento"] / 100.0
									var precio_final = int(round(precio * (1.0 - descuento)))
									
									# volvemos a poner el tag
									var precio_bbcode = "<#b1911a>" + str(precio_final)
									
									plata += int(precio_bbcode.strip_edges().replace("<#b1911a>", ""))
									
									grid.last_hovered_card = null
									grid.arrastrado = null
									grid.dragging = null
									
									#$Viewport/Zona_de_tienda/Baraja_stamps.mazo_original[nombre_domino_a_comprar] = (Diccionarios.amuletos[nombre_domino_a_comprar])
									#$Viewport/Zona_de_tienda/Baraja_stamps.mazo_actual = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.duplicate()
									
									amuletos_tenidos.remove(domino_a_comprar.get_index())
									
									aplicar_efecto(nombre_domino_a_comprar)
									
									if domino_a_comprar.nodo_vinculado:
										domino_a_comprar.nodo_vinculado.queue_free()
									
									domino_a_comprar.queue_free()
									
									Global.usar_offset = true
									domino_a_comprar = null
								
								elif domino_a_comprar.get_parent().name == "Baraja_S":
									var precio_str = Global.dominos_especiales[nombre_domino_a_comprar]["venta"]
									var precio = int(precio_str.replace("<#b1911a>", ""))  # saco el tag
									
									var descuento = Global.stats["descuento"] / 100.0
									var precio_final = int(round(precio * (1.0 - descuento)))
									
									# volvemos a poner el tag
									var precio_bbcode = "<#b1911a>" + str(precio_final)
									
									plata += int(precio_bbcode.strip_edges().replace("<#b1911a>", ""))
									
									s_tenidos.last_hovered_card = null
									s_tenidos.arrastrado = null
									s_tenidos.dragging = null
									
									$Viewport/Zona_de_tienda/Baraja_specials.mazo_original[domino_a_comprar.name] = (Diccionarios.dominos_especiales[domino_a_comprar.name])
									$Viewport/Zona_de_tienda/Baraja_specials.mazo_actual = $Viewport/Zona_de_tienda/Baraja_specials.mazo_original.duplicate()
									
									$Viewport/Zona_de_specials/Baraja_S.mazo_original.erase(domino_a_comprar.name)
									$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
									
									domino_a_comprar.queue_free()
									Global.usar_offset = true
									domino_a_comprar = null
								
								
								get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
								
								if domino_a_comprar != null:
									domino_a_comprar.scale_puede_cambiar = true
									domino_a_comprar = null
									$Viewport/Zona_de_tienda/Menu/Buy/Play_sprites/anim.play("denegar")
									shake_reroll("coin_cancel")
								else:
									shake_reroll("coin")
								
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
					"Delete1":
						boton.position = Vector2(234, -8)
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
	
	#color_actual = "normal"
	
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
		$Viewport/EMPTY, "position:y", $Viewport/EMPTY.position.y, 400,
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
	_a = tween.interpolate_property(
		get_node("Viewport/Cartelitos"), "position:y",
		get_node("Viewport/Cartelitos").position.y, 0,
		1, Tween.TRANS_CUBIC, Tween.EASE_OUT
	)
	
	#print("destino         ", estacion_actual)
	
	get_node("Viewport/Cartelitos/Pick").visible = false
	get_node("Viewport/Cartelitos/Play").visible = false
	get_node("Viewport/Cartelitos/Shop").visible = false
	
	
	if estacion_actual == "seleccion_nivel":
		get_node("Viewport/Cartelitos/Play").visible = true
	
	if estacion_actual == "nivel":
		get_node("Viewport/Cartelitos/Shop").visible = true
	
	if estacion_actual == "tienda":
		get_node("Viewport/Cartelitos/Pick").visible = true
	
	
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
		$Viewport/EMPTY, "position:y", $Viewport/EMPTY.position.y, 84.448,
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
	_a = tween.interpolate_property(
		get_node("Viewport/Cartelitos"), "position:y",
		get_node("Viewport/Cartelitos").position.y, 300,
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
		
		$Viewport/GameArea/Texto_limite/texto.bbcode_text = "[wave amp=50 freq=2] Limit in Game Zone ..."+str(Global.stats.dominos_on_gamezone)+"[/wave]"
	
	if estacion == "tienda":
		var datos = obtener_nivel_sprite()
		
		var spr =  get_node("Viewport/Zona_de_interfaz/Select/1/Level")
		var spr1 = get_node("Viewport/Zona_de_cosas/Level")
		
		spr.region_rect.position = datos["position"]
		spr.region_rect.size = datos["size"]
		
		spr1.region_rect.position = datos["position"]
		spr1.region_rect.size = datos["size"]
		
		color_actual = datos["paleta_colores"]
	
	
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


func obtener_nivel_sprite() -> Dictionary:
	var niveles = Global.niveles
	var stats = Global.stats_base
	
	if !stats["niveles_especiales"]:
		return niveles["default"]
	
	# cada cuantos niveles hay especial
	var cada = stats["cantidad_de_niveles_entre_especial"]
	
	# si no hay niveles especiales, siempre default
	if not stats["niveles_especiales"]:
		return niveles["default"]
	
	# si toca nivel especial
	if nivel_actual % cada == 0 and nivel_actual != 0:
		# juntar todos los niveles excepto default
		var keys = []
		for k in niveles.keys():
			if k != "default":
				keys.append(k)
		
		# calcular chance total
		var total_chance = 0
		for nombre in keys:
			total_chance += niveles[nombre]["chance"]
		
		# tirar probabilidad
		var rng2 = RandomNumberGenerator.new()
		rng2.randomize()
		var roll = rng2.randf_range(0, total_chance)
		
		# seleccionar nivel segun chance
		var acumulado = 0
		for nombre in keys:
			acumulado += niveles[nombre]["chance"]
			if roll <= acumulado:
				return niveles[nombre]
	
	# si no es especial, vuelve default
	return niveles["default"]


func _on_aparecer_completo(estacion) -> void:
	if estacion == "nivel":
		_set_puntos_temp(0)
		
		$Viewport/Baraja.mazo_actual = $Viewport/Baraja.mazo_original.duplicate()
		$Viewport/Baraja.draw_cards(Global.stats.max_cards_in_hand)
		
		$Viewport/Zona_de_specials/Baraja_S.mazo_actual = $Viewport/Zona_de_specials/Baraja_S.mazo_original.duplicate()
		$Viewport/Zona_de_specials/Baraja_S.draw_cards(Global.stats.max_specials_cards_in_hand)
		
		if bandera_nivel:
			bandera_nivel = false
	
	Global.usar_offset = true
	
	if estacion == "tienda":
		$Viewport/Zona_de_tienda/Baraja_normales.mazo_actual = $Viewport/Zona_de_tienda/Baraja_normales.mazo_original.duplicate()
		$Viewport/Zona_de_tienda/Baraja_normales.draw_cards(Global.stats.max_cards_normal_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.normales_pueden_tener_stamps)
		
		$Viewport/Zona_de_tienda/Baraja_specials.mazo_actual = $Viewport/Zona_de_tienda/Baraja_specials.mazo_original.duplicate()
		$Viewport/Zona_de_tienda/Baraja_specials.draw_cards(Global.stats.max_cards_specials_in_store, Global.stats.dominos_en_shop_tener_stamps or Global.stats.specials_pueden_tener_stamps)
		
		$Viewport/Zona_de_tienda/Baraja_stamps.mazo_actual = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.duplicate()
		
		$Viewport/Zona_de_tienda/Baraja_stamps.amuletos_gratis_restantes = Global.stats.amuletos_gratis_por_tienda
		
		$Viewport/Zona_de_tienda/Baraja_stamps.draw_stamps(Global.stats.max_stamps_in_store)
		
		bandera_colores_mult = false
	
	if estacion == "seleccion_nivel":
		if Global.leer_save("Partida", "Nivel_Maximo_actual", 0) < nivel_actual: Global.guardar_save("Partida", "Nivel_Maximo_actual", nivel_actual)
		
		Global.guardar_save("Partida", "Nivel",                nivel_actual)
		Global.guardar_save("Partida", "Money",                plata)
		Global.guardar_save("General", "Partida_guardada",     true)
		Global.guardar_save("Partida", "Mazo_actual_normal",   $Viewport/Baraja.mazo_original)
		Global.guardar_save("Partida", "Mazo_actual_especial", $Viewport/Zona_de_specials/Baraja_S.mazo_original)
		Global.guardar_save("Partida", "Mazo_actual_amuletos", amuletos_tenidos)
		
		var array = []
		var nodo = $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
		
		
		for i in nodo.get_children():
			array.append(i.valores_diccionario)
		
		Global.guardar_save("Partida", "Mazo_valores_amuletos", array)
		
		var contadores_amuletos = 0
		
		for k in amuletos_tenidos:
			var amuleto_nodo  = get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(contadores_amuletos)
			
			if k == "Crystal Dice":
				aplicar_efecto("Crystal Dice", true)
				
				var rng_colores = RandomNumberGenerator.new()
				
				var amuleto_a_copiar = "Crystal Dice"
				
				var posible = false
				
				for a in amuletos_tenidos:
					if a != "Crystal Dice":
						posible = true
				
				if posible:
					while amuleto_a_copiar == "Crystal Dice":
						rng_colores.randomize()
						amuleto_a_copiar = amuletos_tenidos[rng_colores.randi_range(0, amuletos_tenidos.size()-1)]
				else:
					amuleto_a_copiar = "null"
				
				amuleto_nodo.valores_diccionario["Crystal Dice"][1] = amuleto_a_copiar
				amuleto_nodo.nodo_vinculado.valores_diccionario["Crystal Dice"][1] = amuleto_a_copiar
				
				if amuleto_a_copiar != "null":
					if Diccionarios.amuletos[amuleto_a_copiar].has("stat"):
						for j in range(Diccionarios.amuletos[amuleto_a_copiar].stat.size()):
							EFECTOS_TEMPORALES_AMULETOS.append([Diccionarios.amuletos[amuleto_a_copiar].accion[j], Diccionarios.amuletos[amuleto_a_copiar].stat[j], "Crystal Dice", true])
						
						aplicar_efecto("Crystal Dice")
						
						if cantidad_borrables_por_tienda_max != Global.stats.cantidad_de_borrables_por_tienda:
							cantidad_borrables_por_tienda += Global.stats.cantidad_de_borrables_por_tienda-cantidad_borrables_por_tienda_max
							cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
							$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
			
			
			contadores_amuletos += 1
	
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
			$Viewport/GameBG.position = (((posision-$Viewport/GameBG.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = (((posision-nodo.position)/40)) + Vector2(estaciones[estacion_aux], 0)
		else:
			camara.position = Vector2(estaciones[estacion_aux], 0)
			$Viewport/GameBG.position = Vector2(estaciones[estacion_aux], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = Vector2(estaciones[estacion_aux], 0)
	else:
		if Global.mover_camara:
			camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			$Viewport/GameBG.position = (((posision-$Viewport/GameBG.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = (((posision-nodo.position)/40)) + Vector2(estaciones[estacion_actual], 0)
		else:
			camara.position = Vector2(estaciones[estacion_actual], 0)
			$Viewport/GameBG.position = Vector2(estaciones[estacion_actual], 0)
			
			for nodo in paleta_de_colores:
				if nodo == "normal": continue
				nodo = $Viewport.get_node(paleta_de_colores[nodo].BG)
				nodo.position = Vector2(estaciones[estacion_actual], 0)
	
	
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
	if texto == "Level Completion: ":
		$Particula_numero.global_position = Vector2(get_node("Viewport/1/1/Money/Monedas").global_position)
		$Particula_numero.scale = Vector2(0.5, 0.5)
		$Particula_numero.mostrar_tipo("plata", plata_a_recibir, 2.0, [20, 50, 40], 0.4)
	else:
		$Particula_numero.global_position = Vector2(get_node("Viewport/1/1/Money/Monedas").global_position)
		$Particula_numero.mostrar_tipo("plata", plata_a_recibir, 2.0, [20, 50, 40], 0.4)
		get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
	
	plata += plata_a_recibir
	
	get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
	
	cashout.append(texto+str(plata_a_recibir))


var cantidad_borrables_por_tienda = 1
var cantidad_borrables_por_tienda_max = 1


func pasar_level():
	if !bandera_nivel:
		
		print(nivel_actual,"   ", Global.nivel_gandor)
		
		if nivel_actual == Global.nivel_gandor and !Global.endless:
			Cargador.goto_scene("res://Scenas/cinematicas/win2.tscn")
		
		var contadores_amuletos = 0
		
		aplicar_efecto("Random Scroll", true)
		
		for k in amuletos_tenidos:
			var amuleto_nodo  = get_node("Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer").get_child(contadores_amuletos)
			
			if k == "Random Scroll":
				var colores = ["rose", "orange", "blue", "green"]
				
				var rng_colores = RandomNumberGenerator.new()
				
				rng_colores.randomize()
				var color = colores[rng_colores.randi_range(0, 3)]
				
				amuleto_nodo.valores_diccionario["Random Scroll"] = color
				amuleto_nodo.nodo_vinculado.valores_diccionario["Random Scroll"] = color
				
				EFECTOS_TEMPORALES_AMULETOS.append(["+25", amuleto_nodo.valores_diccionario["Random Scroll"]+"_%", "Random Scroll", true])
				aplicar_efecto("Random Scroll")
			
			
			if k == "Crystal Dice" and false:
				aplicar_efecto("Crystal Dice", true)
				
				var rng_colores = RandomNumberGenerator.new()
				
				var amuleto_a_copiar = "Crystal Dice"
				
				var posible = false
				
				for a in amuletos_tenidos:
					if a != "Crystal Dice":
						posible = true
				
				if posible:
					while amuleto_a_copiar == "Crystal Dice":
						rng_colores.randomize()
						amuleto_a_copiar = amuletos_tenidos[rng_colores.randi_range(0, amuletos_tenidos.size()-1)]
				else:
					amuleto_a_copiar = "null"
				
				amuleto_nodo.valores_diccionario["Crystal Dice"][1] = amuleto_a_copiar
				amuleto_nodo.nodo_vinculado.valores_diccionario["Crystal Dice"][1] = amuleto_a_copiar
				
				if amuleto_a_copiar != "null":
					if Diccionarios.amuletos[amuleto_a_copiar].has("stat"):
						for j in range(Diccionarios.amuletos[amuleto_a_copiar].stat.size()):
							EFECTOS_TEMPORALES_AMULETOS.append([Diccionarios.amuletos[amuleto_a_copiar].accion[j], Diccionarios.amuletos[amuleto_a_copiar].stat[j], "Crystal Dice", true])
						
						aplicar_efecto("Crystal Dice")
						
						if cantidad_borrables_por_tienda_max != Global.stats.cantidad_de_borrables_por_tienda:
							cantidad_borrables_por_tienda += Global.stats.cantidad_de_borrables_por_tienda-cantidad_borrables_por_tienda_max
							cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
							$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
			
			
			contadores_amuletos += 1
		
		#Global.reproducir_sonido("Comprar_vender", camara.global_position)
		#Global.reproducir_sonido("Comprar_vender_1", camara.global_position)
		#Global.reproducir_sonido("Click", camara.global_position)
		
		bandera_go_seleccion = false
		bandera_go_tienda    = false
		
		bandera_rerrols_y_delete = true
		
		cantidad_borrables_por_tienda = Global.stats.cantidad_de_borrables_por_tienda
		cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
		
		recibir_plata("Level Completion: ", int(plata_por_nivel(nivel_actual)*Global.stats.level_plata_mult*Global.stats.plata_mult))
		
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
		
		bandera_para_botones = true
		bandera_nivel = true


var poder_llamar_a_perder = true


func perder():
	if !poder_llamar_a_perder: return
	
	var stack = get_stack()
	
	# 0 es perder(), 1 es quien la llamo
	if stack.size() > 1:
		var caller = stack[1]
		print("perder() llamada desde:")
		print("  Script:", caller.source)
		print("  Funcion:", caller.function)
		print("  Linea:", caller.line)
	
	print("PERDISTEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE")
	
	return
	
	Global.generar_dominos_basicos()
	
	poder_llamar_a_perder = false
	Global.desbloquear = true
	print("perdiste")
	#Global.guardar_save("Partida", "Nivel_Maximo",  Global.leer_save("Partida", "Nivel_Maximo_actual", 0))
	Global.guardar_save("Partida", "Nivel",                1)
	Global.guardar_save("Partida", "Money",                0)
	Global.guardar_save("General", "Partida_guardada",     false)
	Global.guardar_save("Partida", "Mazo_actual_normal",   Global.dominos.duplicate())
	Global.guardar_save("Partida", "Mazo_actual_especial", {})
	Global.guardar_save("Partida", "Mazo_actual_amuletos", [])
	Global.guardar_save("Partida", "Mazo_valores_amuletos", [])
	Global.guardar_save("Misc", "endless", false)
	Global.endless = false
	
	Cargador.goto_scene("res://Scenas/menus/Menu Principal.tscn")


var mult = 10


func mostrar_cashout():
	$Viewport/Cashout/Cashout.rect_size.y = 75+(cashout.size()*mult)
	
	$Viewport/Cashout/Cashout/Lineas_t.bbcode_text = "[center][wave amp=50 freq=2]\n"+cashout[0]+"\n[/wave]"
	
	for i in range(1, cashout.size()):
		var label_nueva = $Viewport/Cashout/Cashout/Lineas_t.duplicate()
		label_nueva.add_to_group("label_nueva")
		label_nueva.rect_position.y = $Viewport/Cashout/Cashout/Lineas_t.rect_position.y+(i * mult)
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
	Global.sonido_boton()
	camara.get_node("Camera2D").zoom_wave(1, -0.01, 0.2)


func shake_specials(lugar):
	camara.get_node("Camera2D").shake_wave(1, 3, 0.4, lugar)


func crear_amuleto(amuleto, array_valores = {}):
	var grid =  $Viewport/Zona_de_interfaz/Tienda/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
	var grid1 = $Viewport/Zona_de_interfaz/xd/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
	
	var data = Diccionarios.amuletos[amuleto]
	
	var s = amuletos_instancia.instance()
	s.name = amuleto
	s.nombre = amuleto
	
	if !array_valores.empty(): s.valores_diccionario = array_valores.duplicate()
	
	match amuleto:
		"Rose Bloom":
			get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+"+str(s.valores_diccionario["Rose Bloom"][1]), "rose_mult", "Rose Bloom", true])
			get_tree().root.get_node("Game").aplicar_efecto("Rose Bloom")
		
		"Domino Surge":
			for color in s.valores_diccionario["Domino Surge"].keys():
				get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+"+str(s.valores_diccionario["Domino Surge"][color]), color+"_mult", "Domino Surge", true])
				get_tree().root.get_node("Game").aplicar_efecto("Domino Surge")
		
		"Overgrowth":
			for color in s.valores_diccionario["Overgrowth"].keys():
				get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+"+str(s.valores_diccionario["Overgrowth"][color]), color+"_%", "Overgrowth", true])
				get_tree().root.get_node("Game").aplicar_efecto("Overgrowth")
		
		"Random Scroll":
			var color = s.valores_diccionario["Random Scroll"]
			
			if color == "color":
				var colores = ["rose", "orange", "blue", "green"]
				
				var rng_colores = RandomNumberGenerator.new()
				
				rng_colores.randomize()
				color = colores[rng_colores.randi_range(0, 3)]
				
				s.valores_diccionario["Random Scroll"] = color
			
			get_tree().root.get_node("Game").EFECTOS_TEMPORALES_AMULETOS.append(["+25", color+"_%", "Random Scroll", true])
			get_tree().root.get_node("Game").aplicar_efecto("Random Scroll")
		
		
		"Crystal Dice":
			aplicar_efecto("Crystal Dice", true)
			
			var rng_colores = RandomNumberGenerator.new()
			
			var amuleto_a_copiar = s.valores_diccionario["Crystal Dice"][1]
			
			var posible = false
			
			for a in amuletos_tenidos:
				if a != "Crystal Dice":
					posible = true
			
			if posible:
				while amuleto_a_copiar == "Crystal Dice" or amuleto_a_copiar == "null":
					rng_colores.randomize()
					amuleto_a_copiar = amuletos_tenidos[rng_colores.randi_range(0, amuletos_tenidos.size()-1)]
			else:
				amuleto_a_copiar = "null"
			
			s.valores_diccionario["Crystal Dice"][1] = amuleto_a_copiar
			
			if amuleto_a_copiar != "null":
				if Diccionarios.amuletos[amuleto_a_copiar].has("stat"):
					for j in range(Diccionarios.amuletos[amuleto_a_copiar].stat.size()):
						EFECTOS_TEMPORALES_AMULETOS.append([Diccionarios.amuletos[amuleto_a_copiar].accion[j], Diccionarios.amuletos[amuleto_a_copiar].stat[j], "Crystal Dice", true])
					
					aplicar_efecto("Crystal Dice")
					
					if cantidad_borrables_por_tienda_max != Global.stats.cantidad_de_borrables_por_tienda:
						cantidad_borrables_por_tienda += Global.stats.cantidad_de_borrables_por_tienda-cantidad_borrables_por_tienda_max
						cantidad_borrables_por_tienda_max = Global.stats.cantidad_de_borrables_por_tienda
						$Viewport/Zona_de_tienda/Menu/Delete1/Costo/Label2.bbcode_text = "...%s" % [str(cantidad_borrables_por_tienda)]
	
	
	#print("s.nombre ", s.nombre)
	
	s.get_node("Sprite").region_rect.position = data["position"]
	s.get_node("Sprite").region_rect.size = data["size"]
	#s.rect_global_position = Vector2(208, 0)
	
	s.set_meta("base_pos", s.get_node("Sprite").position)
	
	#$Viewport/Zona_de_tienda/Baraja_stamps.mazo_original.erase(amuleto)
	
	# Configurar labels
	var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
	var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
	var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
	
	for label in [titulo_label, desc_label, costo_label]:
		label.bbcode_enabled = true
	
	titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
	desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
	costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["venta"])) + "[color=#b1911a]" + Global.prefix_plata
	
	# al crear ambos
	
	grid.add_child(s)
	
	var s1 = s.duplicate()
	s1.nombre = amuleto
	
	s1.valores_diccionario = s.valores_diccionario.duplicate()
	
	grid1.add_child(s1)
	
	s.nodo_vinculado = s1
	s1.nodo_vinculado = s


func crear_special_tienda(nombre):
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
				
				get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
				get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
				
				shake_reroll("coin")
				return
		
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
				
				get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
				get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
				
				shake_reroll("coin")
				return
		
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
				
				shake_reroll("coin")
				return
	
	get_node("Viewport/1/1/Money/Monedas/Monedas").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(plata)+Global.prefix_plata+"\n[/wave]"
	get_node("Viewport/1/1/Money/AnimationPlayer").play("mover")
	
	shake_reroll("coin_cancel")


func shake_reroll(para_plata = "normal"):
	camara.get_node("Camera2D").rot_wave(2, 1, 0.2)
	camara.get_node("Camera2D").zoom_wave(2, 0.01, 0.2)
	
	match para_plata:
		"sonido_conseguir":
			Global.reproducir_sonido("Comprar_vender", camara.global_position)
			Global.reproducir_sonido("Click", camara.global_position)
		"coin":
			Global.reproducir_sonido("Comprar_vender", camara.global_position)
			#Global.reproducir_sonido("Comprar_vender_1", camara.global_position)
			Global.reproducir_sonido("Click", camara.global_position)
		"coin_cancel":
			Global.reproducir_sonido("Denied", camara.global_position)
			#Global.reproducir_sonido("Comprar_vender_1", camara.global_position)
			Global.reproducir_sonido("Comprar_vender_3", camara.global_position)


onready var size_amuleto_usable = $Viewport/Open_charm/tope/cuerpo.region_rect.size


func usar_amuleto(amuleto):
	if amuleto == "borrar":
		if cantidad_borrables_por_tienda <=0:
			return
	
	var charm = get_node("Viewport/Open_charm")
	
#	yield(get_tree(), "idle_frame")
#	charm.get_node("tope/Pixe").visible = true
#	yield(get_tree(), "idle_frame")
#	yield(get_tree(), "idle_frame")
#	charm.get_node("tope/Pixe").visible = false
	
	baraja_activa = "usando_amuleto"
	charm.scale = Vector2(1, 1)
	charm.rotation_degrees = 0
	charm.visible = true
	
	var nombre_sin_pack = amuleto
	nombre_sin_pack = nombre_sin_pack.substr(0, nombre_sin_pack.length() - " Pack".length())
	
	print(nombre_sin_pack)
	
	if Diccionarios.stamps.keys().has(nombre_sin_pack):
		charm.get_node("tope/cuerpo/stamp").region_rect.position = Diccionarios.stamps[nombre_sin_pack].position
	else:
		charm.get_node("tope/cuerpo/stamp").region_rect.position = Vector2(-28, 136)
	
	if amuleto.ends_with("Stamp Pack") and amuleto != "Super Stamp Pack":
		var aux_amuleto = amuleto
		var aux = $Viewport/Zona_de_tienda/Baraja_stamps.mazo_original[amuleto]
		
		amuleto = "*StampName* Pack"
		
		Diccionarios.amuletos[amuleto] = aux
		
		Diccionarios.amuletos["*StampName* Pack"].stamp = aux_amuleto.split(" ")[0]+" "+aux_amuleto.split(" ")[1]
	
	if amuleto != "borrar":
		charm.get_node("tope/godray").visible = true
		charm.get_node("tope/cuerpo").region_rect.size = size_amuleto_usable
		charm.get_node("tope/cuerpo").region_rect.position = Diccionarios.amuletos[amuleto]["position"] + Vector2(0, 6)
	else:
		charm.get_node("tope/godray").visible = false
		charm.get_node("tope/cuerpo").region_rect.size = Vector2(0, 0)
	
	amuleto_siendo_usado = amuleto
	
	if amuleto_siendo_usado == "Inverted Pack" or amuleto == "borrar":
		if  amuleto != "borrar":
			get_node("Viewport/Open_charm/tope/AnimatedSprite").animation = "inverso"
		else:
			get_node("Viewport/Open_charm/tope/AnimatedSprite").animation = "anashe"
		
		$Viewport/Open_charm/tope/seleccion/dominos.material.set_shader_param("usar", true)
	else:
		get_node("Viewport/Open_charm/tope/AnimatedSprite").animation = "default"
		$Viewport/Open_charm/tope/seleccion/dominos.material.set_shader_param("usar", false)
	
	# activar temblor
	if  amuleto != "borrar":
		charm_shake_time = 0.0
	else:
		charm_shake_time = 0.5
	
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
	
	Global.reproducir_sonido("Enemy_death", camara.global_position)
	
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


func invocar_cosas(amuleto):
	match amuleto: #   PARA LOS QUE HACEN ALGO MUY ESPECIFICO
		"Color Infusion Pack":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps or Global.stats.packs_pueden_tener_stamps, ["naranja", "rosa", "azul", "verde"])
			return
		
		"Chainmaker Pack":
			var colores = {"naranja" : 0, "rosa" : 0, "azul" : 0, "verde" : 0}
			
			for i in $Viewport/Baraja.mazo_original:
				for c in colores:
					if i.begins_with(c + "_"):
						colores[c] += 1
			
			var mayor_color = ""
			var mayor_valor = -1
			
			for c in colores:
				if colores[c] > mayor_valor:
					mayor_valor = colores[c]
					mayor_color = c
			
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps or Global.stats.packs_pueden_tener_stamps, [mayor_color])
			return
		
		"Focused Pack":
			var colores = {"naranja" : 0, "rosa" : 0, "azul" : 0, "verde" : 0}
			
			for i in $Viewport/Baraja.mazo_original:
				for c in colores:
					if i.begins_with(c + "_"):
						colores[c] += $Viewport/Baraja.mazo_original[i].usado
			
			var mayor_color = ""
			var mayor_valor = -1
			
			for c in colores:
				if colores[c] > mayor_valor:
					mayor_valor = colores[c]
					mayor_color = c
			
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps or Global.stats.packs_pueden_tener_stamps, [mayor_color])
			return
		
		"Inverted Pack":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps, ["naranja", "rosa", "azul", "verde"], "<#e0483e>Delete This Color")
			return
		
		
		"borrar":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps, ["naranja", "rosa", "azul", "verde"], "<#e0483e>Delete This Domino")
			return
		
		
		"Overflow Pack":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps or Global.stats.packs_pueden_tener_stamps)
			
			var keys = $Viewport/Baraja.mazo_original.keys()
			
			for _i in range(2):
				rng1.randomize()
				$Viewport/Baraja.mazo_original.erase(keys[rng1.randi_range(0, keys.size() - 1)])
			
			return
		
		
		"*StampName* Pack":
			$Viewport/Open_charm/tope/seleccion/stamps.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text =  "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/stamps.draw_stamps(Diccionarios.amuletos[amuleto].cuantos, [Diccionarios.amuletos[amuleto].stamp])
			return
	
	
	
	match Diccionarios.amuletos[amuleto].tipo_domino:
		"normal":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/normals.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps  or Global.stats.packs_pueden_tener_stamps)
		"special":
			$Viewport/Open_charm/tope/seleccion/dominos.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text = "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/specials.draw_cards(Diccionarios.amuletos[amuleto].cuantos, Diccionarios.amuletos[amuleto].stamps or Global.stats.packs_pueden_tener_stamps)
		"stamp":
			$Viewport/Open_charm/tope/seleccion/stamps.visible = true
			$Viewport/Open_charm/tope/seleccion/NEW.bbcode_text =  "[center][wave amp=13 freq=1]\n Choose... "+ str(Diccionarios.amuletos[amuleto].cuantos_agarrables) +" [/wave][/center]"
			$Barajas_seleccion/stamps.draw_stamps(Diccionarios.amuletos[amuleto].cuantos)


func salir_de_usable(es_estampa = false):
	shake_reroll()
	
#	var charm = get_node("Viewport/Open_charm")
#	yield(get_tree(), "idle_frame")
#	charm.get_node("tope/Pixe").visible = true
#	yield(get_tree(), "idle_frame")
#	charm.get_node("tope/Pixe").visible = false
	
	var base = "Viewport/Open_charm/tope/"
	var cuerpo = get_node(base + "cuerpo")
	var anim = get_node(base + "AnimatedSprite")
	var godray = get_node(base + "godray")
	var animador = get_node(base + "AnimationPlayer")
	
	if !es_estampa:
		animador.play("Nueva Animación")
		animador.stop()
		animador.seek(0.0, true)
	
	charm_shaking = 0
	
	_aplicar_dissolve(0.0)
	
	cuerpo.get_node("stamp").region_rect.position = Vector2(-28, 136)
	
	dissolve_value = 0.0
	
	$Barajas_seleccion/EMPTY.visible = false
	
	$Viewport/Open_charm/tope/seleccion.visible         = false
	
	if !es_estampa:
		$Viewport/Open_charm/tope/Menu.visible          = false
	
	$Barajas_seleccion/stampa_a_colocar.visible         = false
	
	$Viewport/Open_charm/tope/seleccion/dominos.visible = false
	$Viewport/Open_charm/tope/seleccion/stamps.visible  = false
	
	if !es_estampa:
		godray.visible = true
		cuerpo.visible = true
	
	cuerpo.material.set_shader_param("dissolve_value", 0.0)
	anim.material.set_shader_param("dissolve_value", 0.0)
	
	if !es_estampa:
		baraja_activa = "baraja"
	
	for i in $Barajas_seleccion.get_children():
		if i == $Barajas_seleccion/stampa_a_colocar or i == $Barajas_seleccion/stampa_mouse or i == $Barajas_seleccion/EMPTY:
			continue
		
		if i.dragging != null:
			i.dragging.free()
		
		i.last_hovered_card = null
		i.arrastrado = null
		i.dragging = null
		
		i.mazo_actual = i.mazo_original.duplicate()
		
		for k in i.get_children():
			k.free()
	
	amuleto_siendo_usado = ""


func _aplicar_dissolve(valor):
	var base = "Viewport/Open_charm/tope/"
	var cuerpo = get_node(base + "cuerpo")
	var anim = get_node(base + "AnimatedSprite")
	
	if cuerpo.material:
		cuerpo.material.set_shader_param("dissolve_value", valor)
	if anim.material:
		anim.material.set_shader_param("dissolve_value", valor)


func colocar_stampa(stampa, _a_donde):
	var charm = get_node("Viewport/Open_charm")
	
	#baraja_activa = "colocando_stamp"
	
	charm.get_node("tope/Pixe").visible = false
	yield(get_tree(), "idle_frame")
	charm.get_node("tope/Pixe").visible = true
	yield(get_tree(), "idle_frame")
	charm.get_node("tope/Pixe").visible = false
	
	$Barajas_seleccion/stampa_a_colocar.visible = true
	$Barajas_seleccion/stampa_mouse.visible = true
	
	var titulo_label = get_node("Barajas_seleccion/stampa_a_colocar/Descripcion/MarginContainer/Titulo/Label")
	var desc_label   = get_node("Barajas_seleccion/stampa_a_colocar/Descripcion/MarginContainer/Descripcion/Label")
	var costo_label  = get_node("Barajas_seleccion/stampa_a_colocar/Descripcion/MarginContainer/Costo/Label")
	
	titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(Diccionarios.stamps[stampa]["titulo"]))
	desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(Diccionarios.stamps[stampa]["descripcion"]))
	costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(Diccionarios.stamps[stampa]["plata"])) + "[color=#b1911a]" + Global.prefix_plata
	
	
	$Barajas_seleccion/stampa_a_colocar.region_rect.position = Diccionarios.stamps[stampa].position
	$Barajas_seleccion/stampa_a_colocar.region_rect.size     = Diccionarios.stamps[stampa].size
	
	var posision = Diccionarios.stamps[stampa].position
	
	match stampa:
		"Golden Stamp":
			posision = Vector2(1, 0)
		
		"Silver Stamp":
			posision = Vector2(1, 32)
		
		"Bronze Stamp":
			posision = Vector2(17, 16)
	
	$Barajas_seleccion/stampa_mouse.region_rect.position = posision
	$Barajas_seleccion/stampa_mouse.region_rect.size     = Diccionarios.stamps[stampa].size
	
	if _a_donde == "all" and stampa != "Double Stamp":
		$Barajas_seleccion/specials.draw_cards(5, false, "", 3, true)
		if $Barajas_seleccion/specials.get_child_count() == 0:
			$Barajas_seleccion/EMPTY.visible = true
		else:
			$Barajas_seleccion/EMPTY.visible = false
	else:
		$Barajas_seleccion/specials.draw_cards(5, false, "", 2, true)
		if $Barajas_seleccion/specials.get_child_count() == 0:
			$Barajas_seleccion/EMPTY.visible = true
		else:
			$Barajas_seleccion/EMPTY.visible = false
	
	stampa_a_colocar = stampa


var stampa_a_colocar = ""


func insertar_stampa(domino, stampa = stampa_a_colocar):
	if baraja_activa == "esperar_un_cacho":
		return
	
	
	domino.get_node("Shadow").free()
	
	
	if domino.yo.titulo == "<#e0483e>Stamp <#e0483e>Master":
		if domino.yo.stamps.size() == 0:
			domino.yo.stamps.append([stampa, Vector2(0, 0)])
			domino.poner_stamps()
		pass
	
	
	domino.yo.stamps.append([stampa, (get_global_mouse_position()-domino.global_position)*0.7])
	
	domino.poner_stamps()
	
	Global.reproducir_sonido("Comprar_vender_1", camara.global_position)
	
	var script_name = domino.get_script().resource_path.get_file().get_basename()
	
	match script_name:
		"Normals_tienda_seleccion":
			$Viewport/Baraja.mazo_original[domino.name] = domino.yo
			
			$Viewport/Menu_info/Cartas_normales/Rojo.mazo_original     = $Viewport/Baraja.mazo_original.duplicate()
			$Viewport/Menu_info/Cartas_normales/Azul.mazo_original     = $Viewport/Baraja.mazo_original.duplicate()
			$Viewport/Menu_info/Cartas_normales/Verde.mazo_original    = $Viewport/Baraja.mazo_original.duplicate()
			$Viewport/Menu_info/Cartas_normales/Amarillo.mazo_original = $Viewport/Baraja.mazo_original.duplicate()
			
			Global.usar_stamp_en_domino(stampa, domino, "normal")
		
		"Specials_tienda_seleccion":
			$Viewport/Zona_de_specials/Baraja_S.mazo_original[domino.name] = domino.yo
			
			Global.usar_stamp_en_domino(stampa, domino, "especial")
	
	stampa_a_colocar = ""
	baraja_activa = "esperar_un_cacho"


#      EFECTOS_TEMPORALES_AMULETOS.append(["x2", stat, amuleto, bool])
func aplicar_efecto(_amuleto, borrar = false):
	for i in EFECTOS_TEMPORALES_AMULETOS.duplicate():
		if i[2] != _amuleto:
			continue
		
		var operador = str(i[0])[0]
		var valor = float(str(i[0]).substr(1))
		var stat = i[1]
		
		if amuletos_tenidos.has(_amuleto) and !borrar:
			# aplicar
			if i[3]:
				match operador:
					"x":
						if Global.stats[stat] is bool:
							Global.stats[stat] = false
						else:
							Global.stats[stat] *= valor
					
					"+":
						if Global.stats[stat] is bool:
							Global.stats[stat] = true
						else:
							Global.stats[stat] += valor
					
					"-":
						if Global.stats[stat] is bool:
							Global.stats[stat] = false
						else:
							Global.stats[stat] -= valor
					
					"_":
						Global.stats[stat] = valor
				
				i[3] = false
		else:
			EFECTOS_TEMPORALES_AMULETOS.erase(i)
			recalcular_stat(stat)
		
		#print(Global.stats[stat])


func recalcular_stat(stat):
	var base = Global.stats_base[stat]
	
	for e in EFECTOS_TEMPORALES_AMULETOS+EFECTOS_TEMPORALES:
		if e[1] != stat:
			continue
		
		var operador = str(e[0])[0]
		var valor = float(str(e[0]).substr(1))
		
		match operador:
			"x":
				if base is bool:
					base = false
				else:
					base *= valor
			
			"+":
				if base is bool:
					base = true
				else:
					base += valor
			
			"-":
				base -= valor
			
			"_":
				base = valor
	
	Global.stats[stat] = base


func crear_stats():
	var nodo_base = $"Viewport/Menu_info/STATS/Baraja_S/scroll_stats/MarginContainer/GridContainer"
	
	for i in nodo_base.get_children():
		if i.name != "base":
			i.free()
	
	var cont = 0
	
	for i in Global.stats_base_english.keys():
		var nombre = Global.stats_base_english[i]
		var valor  = Global.stats[i]
		var valor_viejo  = Global.stats_base[i]
		
		var color_abridor  = ""
		var color_cerrador = ""
		
		var valor_menor = valor < valor_viejo
		var valor_mayor = valor > valor_viejo
		
		if   valor_menor:
			color_abridor  = "[color=#ff3b3b]"
			color_cerrador = "[/color]"
		
		elif valor_mayor:
			color_abridor  = "[color=#00ff2e]"
			color_cerrador = "[/color]"
		
		if typeof(valor) == TYPE_STRING:
			valor = valor.replace("<#b1911a>", "[color=#b1911a]c")
			valor = valor+"[/color]"
			color_abridor  = ""
			color_cerrador = ""
		
		var control_nuevo = nodo_base.get_node("base").duplicate()
		
		control_nuevo.get_node("nombre").bbcode_text = "[wave amp=13 freq=1]"+color_abridor+str(nombre)+color_cerrador+" ....[/wave]"
		control_nuevo.get_node("valor").bbcode_text  = "[right][wave amp=13 freq=1].... "+color_abridor+str(valor)+color_cerrador+"[/wave][/right]"
		
		control_nuevo.visible = true
		
		nodo_base.add_child(control_nuevo)
		
		control_nuevo.name = str(cont)
		
		cont += 1
