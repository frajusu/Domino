extends Node

var loader
var wait_frames = -10
var time_max = 100
var current_scene
var pantalla = preload("res://Scenas/pantalla_carga.tscn")
var escena_a_ir = ""
var escena_cambiada = false   # NUEVO


func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	if get_tree().get_nodes_in_group("pantalla_carga").size() != 0:
		goto_scene("res://Scenas/menus/Menu Principal.tscn", true)
		add_child(get_tree().get_nodes_in_group("pantalla_carga")[0].duplicate())
		get_tree().get_nodes_in_group("pantalla_carga")[0].queue_free()


func goto_scene(path, flag = false):
	if !has_node("pantalla_carga"):
		set_process(true)
		escena_a_ir = path
		escena_cambiada = false   # RESETEAR FLAG
		if flag == false:
			var instancia_pantalla = pantalla.instance()
			add_child(instancia_pantalla)
			wait_frames = 10
		else:
			wait_frames = 50


func _physics_process(_time):
	if wait_frames > 0:
		wait_frames -= 1
		return
	
	if wait_frames == 0:
		var parte1 = false
		var parte2 = false
		
		if get_tree().get_nodes_in_group("pantalla_carga").size() != 0:
			parte1 = get_tree().get_nodes_in_group("pantalla_carga")[0].parte_1_terminada
			parte2 = get_tree().get_nodes_in_group("pantalla_carga")[0].parte_2_terminada
		
		# Solo cambiar de escena una vez
		if parte1 and not escena_cambiada:
			var _a = get_tree().change_scene(escena_a_ir)
			escena_cambiada = true
		
		if parte1 and parte2:
			if has_node("pantalla_carga"):
				if !Global.tutorial:
					get_tree().paused = false
				get_node("pantalla_carga").queue_free()
				print("HASJKDHJKASD")
			wait_frames = -10
	
	if wait_frames == -10:
		if has_node("pantalla_carga"):
			if !Global.tutorial:
				get_tree().paused = false
			get_node("pantalla_carga").queue_free()
