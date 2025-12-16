extends Node2D


var ejecutandose = false

var siguiente = 1


func reproducir_siguiente_tuto(actual : String):
	$Select/impares.play(actual)
	siguiente = int(actual)+1
	ejecutandose = true


func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen") and get_tree().paused:
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("click"):
		if ejecutandose:
			var ap = $Select/impares
			ap.seek(ap.current_animation_length, true) # ir al ultimo frame
			ap.stop() # dispara animation_finished
			ejecutandose = false
		else:
			reproducir_siguiente_tuto(str(siguiente))


func _on_impares_animation_finished(_anim_name):
	ejecutandose = false
