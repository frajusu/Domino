extends Node


var loader
var wait_frames = -10
var time_max = 100
var current_scene
var pantalla = preload("res://Scenas/pantalla_carga.tscn")
var escena_a_ir = ""


func _ready():
	if get_tree().get_nodes_in_group("pantalla_carga").size() != 0:
		goto_scene("res://Scenas/menus/Menu Principal.tscn", true)


func goto_scene(path, flag = false):
	if !has_node("pantalla_carga"):
		set_process(true)
		escena_a_ir = path
		if flag == false:
			var instancia_pantalla = pantalla.instance()
			add_child(instancia_pantalla)
			wait_frames = 10
		
		if flag == true:
			wait_frames = 50


func _physics_process(_time):
	if wait_frames > 0:
		wait_frames -= 1
		return
	
	if wait_frames == 0:
		var _a = get_tree().change_scene(escena_a_ir)
		
		for i in get_children():
			print(i.name)
		
		if has_node("pantalla_carga"):
			get_node("pantalla_carga").queue_free()
		
		wait_frames = -10
	
	if wait_frames == -10:
		if has_node("pantalla_carga"):
			get_node("pantalla_carga").queue_free()
	
	if Global.llamada == false:
		if get_tree().root.has_node("mmundo"):
			Global.otro_ready()
			Global.llamada = true
