extends Node2D


var modulate_target = 80

var duracion = 0.2

var menu_actual = 1


func mostrarse():
	$Black.visible = true
	while $Black.self_modulate.a8 < modulate_target:
		yield(get_tree(), "idle_frame")
		$Black.self_modulate.a8 += 20
	
	$Black.self_modulate.a8 = modulate_target
	
	# --- TRANS_BACK manual ---
	var menu = $Menu_info
	var inicio_y = menu.rect_position.y
	var final_y = -114
	
	var tiempo = 0.0
	var s = 1.70158
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# TRANS_BACK + EASE_OUT
		t -= 1
		var suav = (t * t * ((s + 1) * t + s) + 1)
		
		menu.rect_position.y = lerp(inicio_y, final_y, suav)
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	menu.rect_position.y = final_y


func ocultarse():
	while $Black.self_modulate.a8 > 0:
		yield(get_tree(), "idle_frame")
		$Black.self_modulate.a8 -= 20
	
	$Black.visible = false
	$Black.self_modulate.a8 = 0
	
	
	# --- TRANS_BACK manual ---
	var menu = $Menu_info
	var inicio_y = menu.rect_position.y
	var final_y = 230
	var tiempo = 0.0
	var s = 1.70158
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# TRANS_BACK + EASE_IN
		var suav = t * t * ((s + 1) * t - s)
		
		menu.rect_position.y = lerp(inicio_y, final_y, suav)
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	menu.rect_position.y = final_y
	
	$Black.visible = false
	
	get_tree().paused = false


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and $Black.visible == true and $Black.self_modulate.a8 == modulate_target:
		ocultarse()
	
	
	if get_tree().paused == true:
		Global.pause_mode = Node.PAUSE_MODE_PROCESS
		
		Global.bandera_mouse = false
		
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen
		
		for i in $Menu_info/Botones.get_children():
			if i.name == "izq" or i.name != "der":
				continue
			
			i.get_child(1).visible = false
		
		$Menu_info/Botones.get_child(menu_actual).get_child(1).visible = true
		
		for boton1 in [get_node("Menu_info/Botones/der"), get_node("Menu_info/Botones/izq")]:
			var boton = boton1.get_node("Sombra").rect_global_position
			boton += boton1.get_node("Sombra").rect_size/2
			boton.y -= 3
			
			var diferencia = Vector2(12, 12)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.x - diferencia.x and pos.x < boton.x + diferencia.x
			var dentro_y = pos.y > boton.y - diferencia.y and pos.y < boton.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				Global.bandera_mouse = true
				pass
