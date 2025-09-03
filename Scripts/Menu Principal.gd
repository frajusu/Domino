extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}

var mover_letras = true

export(float) var amplitude = 5.0
export(float) var speed = 2.0
export(float) var rotation_amount = 3.0 # degrees of rotation for the middle letter
export(float) var rotation_speed = 1.5  # speed of rotation
export(float) var rotation_offset = 90.0 # base rotation in degrees

var letters = []



func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	
	if mover_letras:
		# Get all child letters (run only once)
		if letters.empty():
			letters = $Viewport/Letras.get_children()
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
	
	
	get_node("CanvasLayer/Mira/Tex_mira").frame = 2
	
	if !Global.mostrar_mouse:
		Input.mouse_mode =Input.MOUSE_MODE_HIDDEN
	
	$CanvasLayer.visible = Global.mostrar_cursor_de_game
	
	var posision = get_global_mouse_position()
	var diferenciax = 40
	var diferenciay = 20
	
	var camara = get_node("Viewport/Camera2D")
	camara.position = (((posision-camara.position)/40))
	
	#get_node("BackGround").position.x -= 0.1
	
	for i in get_node("Viewport/Menu").get_child_count():
		var boton = get_node("Viewport/Menu").get_child(i)
		if boton.name == "Quit":
			diferenciax = 40
			diferenciay = 25
		if boton.name == "Options":
			diferenciax = 50
			diferenciay = 25
		
		if boton.name == "Discord":
			diferenciax = 14
			diferenciay = 14
		
		if boton.visible == false:
			return
		
		if posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax:
			if posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay:
				get_node("CanvasLayer/Mira/Tex_mira").frame = 1
				var diferencia_x_de_posisiones = abs(posision.x)-abs(boton.get_node("Play_sprites").global_position.x)
				var diferencia_y_de_posisiones = abs(boton.get_node("Play_sprites").global_position.y)-abs(posision.y)
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					if boton.name == "Quit":
						boton.global_position.y = 68
						boton.global_position.x = 180
						boton.get_node("Play_sprites/Shaw").position.y = 0
						boton.get_node("Play_sprites/Shaw").position.x = 0
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
					if boton.name == "Discord":
						boton.global_position.y = -145
						boton.global_position.x = -225
						boton.get_node("Play_sprites/Shaw").position.y = 0
						boton.get_node("Play_sprites/Shaw").position.x = 0
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.6)
					if boton.name == "Options":
						boton.global_position.y = 66
						boton.global_position.x = -40
						boton.get_node("Play_sprites/Shaw").position.y = -8
						boton.get_node("Play_sprites/Shaw").position.x = 2
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
					if boton.name == "Play":
						boton.global_position.y = 67
						boton.global_position.x = -144
						boton.get_node("Play_sprites/Shaw").position.y = -8
						boton.get_node("Play_sprites/Shaw").position.x = -1
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name] == true:
						botonHover[boton.name] = false
						if boton.name == "Quit":
							get_tree().quit()
							pass
						if boton.name == "Play":
							Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
							pass
					
					if boton.name == "Quit":
						boton.global_position.y = 65
						boton.global_position.x = 178
						boton.get_node("Play_sprites/Shaw").position.y = 3
						boton.get_node("Play_sprites/Shaw").position.x = 2
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					if boton.name == "Options":
						boton.global_position.y = 62
						boton.global_position.x = -39
						boton.get_node("Play_sprites/Shaw").position.y = -5
						boton.get_node("Play_sprites/Shaw").position.x = 1.143
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					if boton.name == "Play":
						boton.global_position.y = 63
						boton.global_position.x = -142
						boton.get_node("Play_sprites/Shaw").position.y = -5
						boton.get_node("Play_sprites/Shaw").position.x = -2.857
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					if boton.name == "Discord":
						boton.global_position.y = -147
						boton.global_position.x = -223
						boton.get_node("Play_sprites/Shaw").position.y = 4
						boton.get_node("Play_sprites/Shaw").position.x = -4
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				
				if boton.name == "Quit":
					boton.get_node("Play_sprites").material.set_shader_param("y_rot", diferencia_x_de_posisiones/8)
					boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
				
				if boton.name == "Options":
					boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/15)
					boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
				
				if boton.name == "Play":
					boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/8)
					boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y_de_posisiones/8)
				
				if boton.name == "Discord":
					boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x_de_posisiones/2)
					boton.get_node("Play_sprites").material.set_shader_param("x_rot", -diferencia_y_de_posisiones/2)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
		if !(posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay and posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax):
			if botonHover[boton.name] == true:
				botonHover[boton.name] = false
			if boton.name == "Quit":
				boton.global_position.y = 65
				boton.global_position.x = 178
				boton.get_node("Play_sprites/Shaw").position.y = 3
				boton.get_node("Play_sprites/Shaw").position.x = 2
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			if boton.name == "Options":
				boton.global_position.y = 62
				boton.global_position.x = -39
				boton.get_node("Play_sprites/Shaw").position.y = -5
				boton.get_node("Play_sprites/Shaw").position.x = 1.143
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			if boton.name == "Play":
				boton.global_position.y = 63
				boton.global_position.x = -142
				boton.get_node("Play_sprites/Shaw").position.y = -5
				boton.get_node("Play_sprites/Shaw").position.x = -2.857
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			if boton.name == "Discord":
				boton.global_position.y = -147
				boton.global_position.x = -223
				boton.get_node("Play_sprites/Shaw").position.y = 4
				boton.get_node("Play_sprites/Shaw").position.x = -4
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
		
		if !(posision.y < boton.global_position.y+diferenciay and posision.y > boton.global_position.y-diferenciay and posision.x < boton.global_position.x+diferenciax and posision.x > boton.global_position.x-diferenciax):
				boton.get_node("Play_sprites/Sprite").use_parent_material = false
