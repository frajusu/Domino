extends CanvasLayer

var parte_1_terminada = false
var parte_2_terminada = false
var escena_a_ir = ""
var es_instancia_original = false



func _ready():
	if get_parent() != Cargador:
		# Crear copia dentro del Cargador
		var copia = duplicate()
		Cargador.add_child(copia)
		
		# Esta instancia es la original independiente → marcarla
		copia.es_instancia_original = true
		$AnimationPlayer.play("parte_2")
		return
	
	# Si ya está dentro del Cargador, arranca normal con parte_1
	$AnimationPlayer.play("parte_1")


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
			pass
		
