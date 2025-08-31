extends Node


var mostrar_mouse = false

var mostrar_cursor_de_game = true


var posision_de_la_mira = Vector2(0, 0)


var frames_restantes = 0


var llamada = false


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




func pausar_juego_por_ciertos_frames(frames):
	frames_restantes = frames
	get_tree().paused = true


func _ready():
	#Engine.time_scale = 1
	OS.set_window_title("Domino")
	otro_ready()


func otro_ready():
	#print("AJSKDG")
	get_parent().get_node("/root/Global").pause_mode  = Node.PAUSE_MODE_PROCESS
	if get_tree().root.has_node("mmundo"):
		otro_otro_ready()


func otro_otro_ready():
	llamada = true


func _physics_process(_delta):
	pass


static func string_to_vector2(string := "") -> Vector2:
	if string:
		var new_string: String = string
		new_string.erase(0, 1)
		new_string.erase(new_string.length() - 1, 1)
		var array: Array = new_string.split(", ")
		
		return Vector2(array[0], array[1])
	
	return Vector2.ZERO
