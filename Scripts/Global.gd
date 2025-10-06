extends Node



var sombras = true
var sombras_dominos_principales = false

var posision_de_la_mira = Vector2(0, 0)

var usar_offset = true

var prefix_plata = "c"

var mover_camara = true

var fijar_dominos = true

var stats = {
	"max_cards_in_hand" : 8,
	"max_specials_cards_in_hand" : 8,
	"max_cards_specials_in_store" : 3,
	"max_cards_normal_in_store" : 3,
	"max_stamps_in_store" : 3,
	"draws" : 3,
	"plays" : 3,
	"start_money" : 0,
	"cost_normal_domino" : "<#b1911a>10",
}


var bandera_mouse = false


var METODO_DE_CAIDA = "2d" #3d o 2d

var simbolos = '↵ ↰ ↱ ↳ ← → ↖ ↗ ↘ ↙'

var dominos = {}

var dominos_especiales = {
	"Bomb" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(208, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Bomb",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino <#e0483e>Explodes when it falls knocking over other dominos.", # ejemplo: "This domino adds <#f3983a>+1"
			},
	"50 Pointer" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(112, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(80, 192),
				"titulo": "<#296e8f>50 Pointer",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino Adds <#296e8f>+50 points when it falls." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"2x Behind" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(80, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>2x Behind",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino <#296e8f>Adds the amount made before itself <#e0483e>times <#e0483e>2." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Banana" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(144, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#e19124>Banana",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino Falls to the front and <#238c73>THEN to the back of itself." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Double" :  {
				"tipo" : "especial",
				"chance": 4,  # algo menos común
				"region_rect_cords": Vector2(176, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Double",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Can knock down <#296e8f>2 dominos." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Multiplier 3x" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(240, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>Multiplier <#e0483e>3x",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#e0483e>Triples everything in the chain if this domino is the <#e0483e>3rd in the <#296e8f>row." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Specific 100" :  {
				"tipo" : "especial",
				"chance": 6,  # algo menos común
				"region_rect_cords": Vector2(272, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(80, 192),
				"titulo": "Specific <#296e8f>100",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Adds <#296e8f>+100 if it’s the <#e0483e>2nd and last in a row." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Reverse" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(304, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Reverse",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#238c73>Reverses the fall direction of a row of dominos." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Long Shot" :  {
				"tipo" : "especial",
				"chance": 4,  # algo menos común
				"region_rect_cords": Vector2(48, 0),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(80, 192),
				"titulo": "<#296e8f>Long Shot",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#296e8f>Adds to the score the number of dominos that fell because of this one." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Sniper" :  {
				"tipo" : "especial",
				"chance": 6,  # algo menos común
				"region_rect_cords": Vector2(48, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(208, 192),
				"titulo": "<#e0483e>Sniper",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Falls with <#238c73>double the normal length." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Eye" :  {
				"tipo" : "especial",
				"chance": 5,  # algo menos común
				"region_rect_cords": Vector2(80, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#e0483e>Eye",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Falls and <#296e8f>adds the score of the domino that contributed the most." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Time Bomb" :  {
				"tipo" : "especial",
				"chance": 4,  # algo menos común
				"region_rect_cords": Vector2(16, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(48, 192),
				"titulo": "<#238c73>Time <#238c73>Bomb",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Activates after 7 other dominos fell, then explodes." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Mirror" :  {
				"tipo" : "especial",
				"chance": 1,  # algo menos común
				"region_rect_cords": Vector2(112, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#76357a>Mirror",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Clones the row it is in but only after itself." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Fire" :  {
				"tipo" : "especial",
				"chance": 2,  # algo menos común
				"region_rect_cords": Vector2(144, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#f04015>Fire",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#f04015>Spreads its effect to all dominos in the chain, giving each <#296e8f>+10 points." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Blue Fire" :  {
				"tipo" : "especial",
				"chance": 1,  # algo menos común
				"region_rect_cords": Vector2(176, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#407cad>Blue <#407cad>Fire",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Like <#f04015>Fire but <#296e8f>adds one tenth of the affected domino’s score, <#e0483e>multiplied by its position number." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Sticky" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(208, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#38b338>Sticky",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "Leaves a <#38b338>”slime <#38b338>trail” Dominos after it lose their momentum, making the chain slower but adding <#296e8f>+5 points per stuck domino." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Ruler" :  {
				"tipo" : "especial",
				"chance": 3,  # algo menos común
				"region_rect_cords": Vector2(240, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(4800, 192),
				"titulo": "<#e19124>Ruler",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "<#296e8f>Adds the distance ( <#e19124>cm ) traveled between each domino from start to finish." # ejemplo: "This domino adds <#f3983a>+1"
			},
	"Stamp Master" :  {
				"tipo" : "especial",
				"chance": 4,  # algo menos común
				"region_rect_cords": Vector2(272, 64),
				"stamps": {},
				"mult": 1,
				"plata": "<#b1911a>10",
				"BG": Vector2(16, 192),
				"titulo": "<#e0483e>Stamp <#e0483e>Master",  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "The next stamp you <#296e8f>add to this domino will be duplicated, also adds +10." # ejemplo: "This domino adds <#f3983a>+1"
			},
}

var stamps = {
	"1+ Domino in Hand" : {"size" : Vector2(16,16),
						   "position" : Vector2(0,0),
						   "plata": "<#b1911a>10",
						   "titulo" : "<#296e8f>+1 <#296e8f>Hand",
						   "descripcion" : "This Stamp adds <#296e8f>+1 to your <#296e8f>Hand of Dominos",
						   },
	
	"1+ Draw" : {"size" : Vector2(16,16),
				 "position" : Vector2(16,0),
				 "plata": "<#b1911a>10",
				 "titulo" : "<#f3983a>+1 <#f3983a>Draw",
				 "descripcion" : "This Stamp adds <#296e8f>+1 to your <#f3983a>Draws of Dominos",
				},
}


var puntaje_inicial_nivel = 80

var frames_restantes = 0

var mostrar_colision_dominos = false


var sonidos = {
	"Shotgun001": ["res://assets/SFX/armas/disparos/Shotgun003.wav", 4, 6, 1],
	"Explosion": ["res://assets/SFX/armas/disparos/Explosion.wav", 4, 6, 1],
}


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
	for label in get_tree().get_nodes_in_group("rich_label"):
		label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if bandera_mouse:
		Input.set_default_cursor_shape(2)
	else:
		Input.set_default_cursor_shape(0)


func pausar_juego_por_ciertos_frames(frames):
	frames_restantes = frames
	get_tree().paused = true


func _ready():
	print(simbolos)
	#Engine.time_scale = 1
	OS.set_window_title("Domino")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	generar_dominos_basicos()


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
				"tipo" : "normal",
				"region_rect_cords": Vector2(16, 0),
				"stamps": {},
				"mult": 1,
				"titulo": "%d <%s>%s" % [numero, hex, en_name],  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino adds <%s>+%d" % [azul, numero] # ejemplo: "This domino adds <#f3983a>+1"
			}


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


static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")
		
		return Vector2(array[0], array[1])
	
	return Vector2.ZERO
