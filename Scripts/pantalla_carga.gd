extends CanvasLayer

var parte_1_terminada = false
var parte_2_terminada = false
var escena_a_ir = ""
var es_instancia_original = false

var mover_letras = true
var letters = []
export(float) var amplitude = 5.0
export(float) var speed = 2.0
export(float) var rotation_amount = 3.0 # degrees of rotation for the middle letter
export(float) var rotation_speed = 1.5  # speed of rotation
export(float) var rotation_offset = 90.0 # base rotation in degrees


func _ready():
	if get_parent() != Cargador:
		# Crear copia dentro del Cargador
		var copia = duplicate()
		Cargador.add_child(copia)
		
		copia.es_instancia_original = true
		$AnimationPlayer.play("parte_2")
		queue_free()
		return
	else:
		$AnimationPlayer.play("parte_1")


func _physics_process(_delta):
	if mover_letras:
		# Get all child letters (run only once)
		if letters.empty():
			letters = $Letras.get_children()
			for letter in letters:
				# Store initial position in metadata
				letter.set_meta("base_pos", letter.position)
		
		var time = OS.get_ticks_msec() / 1000.0 * speed
		
		for i in range(letters.size()):
			var letter = letters[i]
			var base_pos = letter.get_meta("base_pos")
			# Add phase offset for wave effect
			var phase = i * 0.5
			letter.position.y = base_pos.y + sin(time + phase) * amplitude
		
		# Rotate the middle letter slightly left and right around an offset
		if letters.size() > 0:
			var mid_index = letters.size() / 2
			var mid_letter = letters[int(mid_index)]
			# Rotation = offset + sine wave oscillation
			mid_letter.rotation = deg2rad(rotation_offset + sin(time * rotation_speed) * rotation_amount)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "parte_1":
		parte_1_terminada = true
		$AnimationPlayer.play("parte_2")
	
	elif anim_name == "parte_2":
		parte_2_terminada = true
		# si es la original (la que arranca sola), borrarla al terminar
		if es_instancia_original:
			queue_free()
		
		
		if get_tree().root.has_node("Menu_Principal"):
			get_tree().root.get_node("Menu_Principal").menu_actual = "transision_a_default"
