extends Node



var sombras = false

var posision_de_la_mira = Vector2(0, 0)

var usar_offset = true

var mover_camara = true


var stats = {
	"max_cards_in_hand" : 8,
}


var bandera_mouse = false


var METODO_DE_CAIDA = "2d" #3d o 2d


var dominos = {}


var puntaje_inicial_nivel = 80


var frames_restantes = 0



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


func _process(_delta):
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
	#Engine.time_scale = 1
	OS.set_window_title("Domino")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	generar_dominos_basicos()



func generar_dominos_basicos():
	var colores = {
		"rojo":    {"hex": "#f3983a", "en": "Orange"},
		"azul":    {"hex": "#e48b7c", "en": "Pink"},
		"verde":   {"hex": "#3c4368", "en": "Blue"},
		"amarillo":{"hex": "#235955", "en": "Green"},
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
				"region_rect_size": Vector2(32, 64),
				"region_rect_cords": Vector2(16, 0),
				"mult": 1,
				"titulo": "%d <#%s>%s" % [numero, hex, en_name],  # ejemplo: "1 <#f3983a>Red"
				"descripcion": "This domino adds <#%s>+%d" % [azul, numero] # ejemplo: "This domino adds <#f3983a>+1"
			}


static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")
		
		return Vector2(array[0], array[1])
	
	return Vector2.ZERO
