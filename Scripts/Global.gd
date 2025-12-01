extends Node



var sombras = true
var sombras_dominos_principales = false

var posision_de_la_mira = Vector2(0, 0)

var usar_offset = true

var prefix_plata = "c"

var idiomas = ["English"]

var idioma_actual = 0


var sonido = {
	"gen" : true,
	"gen_vol" : 0.5,
	"mus" : true,
	"mus_vol" : 0.5,
	"eff" : true,
	"eff_vol" : 0.5,
}


var plata_mucha = true

var grafico = {
	"overlay": true,
	"overlay_default": false,
	"vignete_opacity": 0.26,
	"wrap": 0.0,
	"noise": 0.021,
	"reducir_colores": true,
}


var continuar = false

var desbloquear = false


const MAT_STAMP = preload("res://assets/shaders/brillito.tres")

const desripcion_para_stamps = preload("res://Scenas/Descripcion.tscn")

var mover_camara = true

var fijar_dominos = true

var stats_base = {
	"max_cards_in_hand" : 8,
	"max_specials_cards_in_hand" : 5,
	"max_cards_specials_in_store" : 3,
	"max_cards_normal_in_store" : 3,
	"max_stamps_in_store" : 3,
	"draws" : 3,
	"plays" : 3,
	"start_money" : 0,
	"cost_normal_domino" : "<#b1911a>10",
	"global_mult" : 1.0,
	"rose_mult" : 1.0,
	"orange_mult" : 1.0,
	"green_mult" : 1.0,
	"blue_mult" : 1.0,
	"reroll_normals"  : 10,
	"reroll_specials" : 10,
	"reroll_amuletos" : 10,
	"dominos_en_shop_tener_stamps" : false,
	"normales_pueden_tener_stamps" : true,
	"specials_pueden_tener_stamps" : false,
	
	"packs_pueden_tener_stamps" : false,
	
	"maximo_stampas" : 1,
	
	"niveles_especiales": false,
	"cantidad_de_niveles_entre_especial" : 1,
	
	"cantidad_de_borrables_por_tienda" : 1,
}


var niveles = {
	"default" : {
		"size" : Vector2(32, 32),
		"position" : Vector2(0, 0),
		"chance" : 5
	},
	"boss_ejemplo" : {
		"size" : Vector2(32, 32),
		"position" : Vector2(48, 0),
		"chance" : 5
	}
}


var stats = stats_base.duplicate()


var bandera_mouse = false # setget set_bandera_mouse

#func set_bandera_mouse(v):
#	bandera_mouse = v
#	print("bandera_mouse cambiada a: ", v, " en ", get_stack())



var METODO_DE_CAIDA = "2d" #3d o 2d

var simbolos = ['→', '↳', '↱', '↘', '↗', '←', '↵', '↰', '↙', '↖', '←←', '→→', '↺']

var dominos = {}

# padre es 0 significa que puede ser padre o hijo, si es 1 solo puede ser hijo, si es 2 solo puede ser padre, si es 3 puede ser padre extra.
var dominos_especiales = Diccionarios.dominos_especiales.duplicate()

var stamps = Diccionarios.amuletos

var puntaje_inicial_nivel = 80

var frames_restantes = 0

var mostrar_colision_dominos = false


var sonidos = {
	"Shotgun001": ["res://assets/SFX/armas/disparos/Shotgun003.wav", 4, 6, 1],
	"Explosion": ["res://assets/SFX/armas/disparos/Explosion.wav", 4, 6, 1],
}


func reproducir_anim_con_delay(nodo, nombre_anim, delay = 1.0):
	var anim_player = nodo.get_node("AnimationPlayer")
	
	# Forzar primer frame de la animación
	anim_player.play(nombre_anim)
	anim_player.stop()
	anim_player.seek(0, true)
	
	# Esperar el delay
	yield(get_tree().create_timer(delay), "timeout")
	
	# Reproducir la animación
	
	# Verificar que el nodo y el AnimationPlayer sigan existiendo
	if !is_instance_valid(nodo):
		return
	if !is_instance_valid(anim_player):
		return
	
	# Reproducir la animación
	anim_player.play(nombre_anim)


func reproducir_sonido(tipo_sonido: String, posision_del_sonido):
	if tipo_sonido in sonidos:
		var sonido_path = sonidos[tipo_sonido][0]
		var audio_stream = AudioStreamPlayer2D.new()
		get_tree().get_nodes_in_group("mmundo")[0].get_node("sonidos").add_child(audio_stream)
		
		audio_stream.stream = load(sonido_path)
		
		#audio_stream.stream.loop = false
		audio_stream.play()
		audio_stream.global_position = posision_del_sonido
		audio_stream.pitch_scale = sonidos[tipo_sonido][3]
		var random123 = RandomNumberGenerator.new()
		random123.randomize()
		audio_stream.volume_db = random123.randi_range(sonidos[tipo_sonido][1], sonidos[tipo_sonido][2])
		
		# Conectar señal para detectar cuando termine el sonido
		audio_stream.connect("finished", self, "_on_sonido_terminado", [audio_stream])


func _physics_process(_delta):
	#print(Global.leer_save("Partida", "Nivel_Maximo", 0))
	
	if get_tree().root.has_node("Game") or get_tree().root.has_node("Menu_Principal"):
		get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").visible = grafico.overlay
		if !grafico.overlay_default:
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("vignette_opacity", grafico.vignete_opacity)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("warp_amount", grafico.wrap)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("static_noise_intensity", grafico.noise)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("posterize_colors", grafico.reducir_colores)
		else:
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("vignette_opacity", 0.262)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("warp_amount", 0.083)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("static_noise_intensity", 0.021)
			get_tree().get_nodes_in_group("camera")[0].get_parent().get_node("camara").material.set_shader_param("posterize_colors", true)
	
	for label in get_tree().get_nodes_in_group("rich_label"):
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
#	if Input.is_action_just_pressed("click"):
#		usar_amuleto_animacion("Domino Tag")
	if bandera_mouse:
		Input.set_default_cursor_shape(2)
	else:
		Input.set_default_cursor_shape(0)


func pausar_juego_por_ciertos_frames(frames):
	frames_restantes = frames
	get_tree().paused = true


func _ready():
	OS.set_window_title("Falaro")
	
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	generar_dominos_basicos()
	
	var ruta_base = OS.get_environment("APPDATA") + "/Falaro"
	
	# crear carpeta si no existe
	var dir = Directory.new()
	if not dir.dir_exists(ruta_base):
		dir.make_dir(ruta_base)
	
	var ruta = ruta_base + "/save.cfg"
	
	var save = ConfigFile.new()
	var error = save.load(ruta)
	
	if error != OK:
		save.set_value("General", "Primera_vez",      true)
		save.set_value("General", "Partida_guardada", false)
		save.set_value("Partida", "Nivel", 1)
		save.set_value("Partida", "Nivel_Maximo", 1)
		save.set_value("Partida", "Nivel_Maximo_actual", 1)
		save.set_value("Partida", "Money", 0)
		save.set_value("Partida", "Mazo_actual_normal", Global.dominos.duplicate())
		save.set_value("Partida", "Mazo_actual_especial", {})
		save.set_value("Partida", "Mazo_actual_amuletos", [])
		save.set_value("Sonidos",  "sonido",  Global.sonido)
		save.set_value("Graficos", "grafico", Global.grafico)
		save.set_value("Misc",     "mover_camara", Global.mover_camara)
		save.set_value("Misc",     "mucha_plata",  Global.plata_mucha)
		save.set_value("Misc",     "idioma",       Global.idioma_actual)
		save.save(ruta)
		print("Archivo creado en: ", ruta)
	else:
		Global.sonido       = Global.leer_save("Sonidos", "sonido")
		Global.grafico      = Global.leer_save("Graficos", "grafico")
		Global.mover_camara = Global.leer_save("Misc", "mover_camara")
		Global.plata_mucha  = Global.leer_save("Misc", "mucha_plata")
		Global.idioma_actual= Global.leer_save("Misc", "idioma")
		print("Archivo ya existe")
	
	
	#print(simbolos)
	#Engine.time_scale = 1


func leer_save(seccion: String, nombre: String, defecto := null):
	var ruta = OS.get_environment("APPDATA") + "/Falaro/save.cfg"
	var save = ConfigFile.new()
	
	if save.load(ruta) != OK:
		return defecto
	
	return save.get_value(seccion, nombre, defecto)


func guardar_save(seccion: String, nombre: String, valor):
	animar_save()
	
	var ruta = OS.get_environment("APPDATA") + "/Falaro/save.cfg"
	
	var save = ConfigFile.new()
	var error = save.load(ruta)
	
	# si no existe el archivo lo creamos
	if error != OK:
		var dir = Directory.new()
		var carpeta = OS.get_environment("APPDATA") + "/Falaro"
		if not dir.dir_exists(carpeta):
			dir.make_dir(carpeta)
	
		save = ConfigFile.new()  # archivo nuevo
	
	# setear dato
	save.set_value(seccion, nombre, valor)
	
	# guardar
	save.save(ruta)


func animar_save():
	var nodo = get_tree().get_nodes_in_group("camera")[0].get_node("Save")
	
	while nodo.self_modulate.a8 < 256:
		yield(get_tree(), "idle_frame")
		nodo.self_modulate.a8 += 10
	
	while nodo.self_modulate.a8 > 0:
		yield(get_tree(), "idle_frame")
		nodo.self_modulate.a8 -= 5
	
	nodo.self_modulate.a8 = 0
	nodo.self_modulate.a = 0.0


func generar_dominos_basicos():
	var colores = {
		"naranja":    {"hex": "#f3983a", "en": "Orange"},
		"rosa":    {"hex": "#e48b7c", "en": "Pink"},
		"azul":   {"hex": "#3c4368", "en": "Blue"},
		"verde":{"hex": "#235955", "en": "Green"},
	}
	
	for color in colores.keys():
		var hex = colores[color]["hex"]
		var azul = "#296e8f"
		var en_name = colores[color]["en"]
		for numero in range(1, 9):  # del 1 al 8
			var nombre = "%s_%d" % [color, numero]
			dominos[nombre] = {
				"puntaje": numero,
				"usado": 0,  # CANTIDAD DE USOS
				"mult_actual": 1,
				"mult_global": 1,
				"mult_siguiente": 1,
				"puntaje_siguiente": 0,
				"tipo" : "normal",
				"color" : str(en_name),  # Orange, Pink, Blue, Green, All
				"plata_que_da" : 0,      # 0
				"region_rect_cords": Vector2(16, 0),
				"flechitas" : ["→"],
				"stamps": [], #[  ["Ascendant Stamp", Vector2(0, 0)], ["Ascendant Stamp", Vector2(8, 20)]  ],
				"mult": 1,
				"padre" : 0,
				"titulo": "%d <%s>%s" % [numero, hex, en_name],  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino adds <%s>+%d" % [azul, numero] # ejemplo: "This domino adds <#f3983a>+1"
			}


func mostrar_alert_error(mensaje):
	print(mensaje)


var orden_colores = ["amarillo", "rojo", "verde", "azul"]


func ordenar_dominos_por_color_y_numero(dominos1: Dictionary) -> Array:
	var claves = dominos1.keys()
	claves.size()
	claves.sort_custom(self, "_comparar_dominos")
	claves.size()
	return claves  # <<< devolvemos array de claves


func _comparar_dominos(a: String, b: String) -> bool:
	var partes_a = a.split("_")
	var partes_b = b.split("_")
	
	var color_a = partes_a[0]
	var color_b = partes_b[0]
	var num_a = int(partes_a[1])
	var num_b = int(partes_b[1])
	
	var idx_a = orden_colores.find(color_a)
	var idx_b = orden_colores.find(color_b)
	
	if idx_a != idx_b:
		return idx_a < idx_b
	return num_a < num_b


func quitar_t_extra(nombre: String) -> String:
	while nombre.ends_with("t"):
		nombre = nombre.substr(0, nombre.length() - 1)
	return nombre


func usar_amuleto_animacion(_amuleto):
	var nodo = get_tree().get_nodes_in_group("camera")[0].get_node("uso_amuleto_anim")
	
	nodo.get_node("Sprite").region_rect.position = Diccionarios.amuletos[_amuleto].position
	
	nodo.get_node("AnimationPlayer").play("anim")


func usar_stamp_en_domino(stampa, domino, tipo):
	match stampa:
		"Stone Stamp":
			if tipo == "normal":
				var baraja = get_tree().root.get_node("Game/Viewport/Baraja")
				print(domino.yo.color)
				baraja.mazo_original[domino.nombre].color = "All"
				domino.yo.color = "All" # Orange, Pink, Blue, Green, All
				print(domino.yo.color)
			else:
				var baraja = get_tree().root.get_node("Game/Viewport/Zona_de_specials/Baraja_S")
				baraja.mazo_original[domino.nombre].color = "All"
				domino.yo.color = "All" # Orange, Pink, Blue, Green, All
		
		"Double Stamp":
			var baraja = get_tree().root.get_node("Game/Viewport/Baraja")
			
			var flechitas = domino.yo.flechitas
			if flechitas.size() == 0:
				return
			
			var max_index = -1
			
			# detectar la flecha mas alta
			for f in flechitas:
				var idx = simbolos.find(f)
				if idx > max_index:
					max_index = idx
			
			# si esta en la ultima, no hay siguiente
			if max_index == simbolos.size() - 1:
				return
			
			var siguiente = simbolos[max_index + 1]
			
			domino.yo.flechitas.append(siguiente)
			
			baraja.mazo_original[domino.nombre] = domino.yo
