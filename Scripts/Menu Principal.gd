extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}


onready var botonPosision =  {  "Play" :     {"global_position" : Vector2(-157, 83)},
								"Options" :  {"global_position" : Vector2(-53, 83)},
								"Quit" :     {"global_position" : Vector2(161.143005, 83)},
								"Discord" :  {"global_position" : Vector2(-237.856995, -127)},
								"NEW" :      {"global_position" : Vector2(-2, -9)},
								"CONTINUE" : {"global_position" : Vector2(-2, 42)},
}


var mover_letras = true

export(float) var amplitude = 5.0
export(float) var speed = 2.0
export(float) var rotation_amount = 3.0 # degrees of rotation for the middle letter
export(float) var rotation_speed = 1.5  # speed of rotation
export(float) var rotation_offset = 90.0 # base rotation in degrees

var letters = []


var encontro_partida_guardada = false


var menu_actual = "asd"


func _ready():
	if get_tree().get_nodes_in_group("pantalla_carga").size() == 0:
		menu_actual = "transision_a_default"
	
	encontro_partida_guardada = encontrar_partida_guardada_sistema()
	get_node("Seleccionar_partida/1/Menu/CONTINUE/Candado").visible = !encontro_partida_guardada
	$Seleccionar_partida.visible = true


func encontrar_partida_guardada_sistema():
	return Global.leer_save("General", "Partida_guardada")


export var shake_duration := 0.5
export var max_scale := 1.2
export var max_rotation_degrees := 15.0
export var oscillations := 2


var is_shaking := false
var shake_timer := 0.0
var original_scale := Vector2()
var original_rotation := 0.0
var nodo_a_sacudir = null


func start_shake(nodo):
	if is_shaking:
		return  # ignora si ya está sacudiéndose
	nodo_a_sacudir = nodo
	original_scale = nodo.scale
	original_rotation = nodo.rotation
	is_shaking = true
	shake_timer = shake_duration


func _physics_process(delta):
	if is_shaking and nodo_a_sacudir:
		shake_timer -= delta
		if shake_timer > 0:
			var t = 1.0 - (shake_timer / shake_duration)
			# Escala tipo boing
			nodo_a_sacudir.scale = original_scale.linear_interpolate(Vector2(max_scale, max_scale), sin(t * PI))
			# Rotacion oscilante
			var rot_factor = sin(t * oscillations * PI * 2)
			nodo_a_sacudir.rotation = original_rotation + rot_factor * deg2rad(max_rotation_degrees)
		else:
			# Reset final
			nodo_a_sacudir.scale = original_scale
			nodo_a_sacudir.rotation = original_rotation
			is_shaking = false
			nodo_a_sacudir = null
	
	
	if menu_actual == "transision_a_default":
		$Viewport/Menu/Discord.position.x = lerp($Viewport/Menu/Discord.position.x, -237.857, 0.1)
		
		$Viewport/Menu/Play.position.y = lerp($Viewport/Menu/Play.position.y, 54, 0.1)
		$Viewport/Menu/Options.position.y = $Viewport/Menu/Play.position.y
		$Viewport/Menu/Quit.position.y = $Viewport/Menu/Play.position.y
		
		$Viewport/fondo_botones.position.y = lerp($Viewport/fondo_botones.position.y, 83, 0.1)
		
		
		if $Viewport/Letras.material.get_shader_param("dissolve_value") < 1:
			$Viewport/Letras.material.set_shader_param("dissolve_value", $Viewport/Letras.material.get_shader_param("dissolve_value")+0.01)
		else:
			if menu_actual == "transision_a_default":
				menu_actual = "default"
	
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
			
			if dragging and dragged_letter == letter:
				continue # si la estamos arrastrando no tocamos su Y
			
			var phase = i * 0.5
			letter.position.y = base_pos.y + sin(time + phase) * amplitude
		
		# Rotate the middle letter slightly left and right around an offset
		if letters.size() > 0:
			var mid_index = letters.size() / 2
			var mid_letter = letters[int(mid_index)]
			# Rotation = offset + sine wave oscillation
			mid_letter.rotation = deg2rad(rotation_offset + sin(time * rotation_speed) * rotation_amount)
	
	
	
	var posision = get_global_mouse_position()
	
	var camara = get_node("Viewport/Camera2D")
	camara.position = (((posision-camara.position)/40))
	$Seleccionar_partida.position = ((($Seleccionar_partida.position-posision)/100))
	
	Global.bandera_mouse = false
	
	if menu_actual == "default":
		var menu = get_node("Viewport/Menu")
		for i in range(menu.get_child_count()):
			if dragging:
				continue # si la estamos arrastrando no tocamos su Y
			var boton = menu.get_child(i)
			if !boton.visible:
				continue
			
			# diferencias por nombre
			var diffs = {
				"Quit":    Vector2(35, 20),
				"Options": Vector2(50, 20),
				"Discord": Vector2(14, 14),
				"Play":    Vector2(35, 20)
			}
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				if !Global.bandera_mouse:
					Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"Quit":
							boton.position = Vector2(163.143, 56)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
						"Discord":
							boton.position = Vector2(-239.857, -154)
							boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.6)
						"Options":
							boton.position = Vector2(-53, 56)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
						"Play":
							boton.position = Vector2(-159, 56)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "Quit":
							get_tree().quit()
						
						if boton.name == "Options":
							$Black.mostrarse()
							get_tree().paused = true
						
						if boton.name == "Play":
							#Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
							mover_suave(get_node("Seleccionar_partida/1"), Vector2(4.143,0), 0.3)
							aprarecer_suave($Sprite, 70, 0.2)
							menu_actual = "select_partida"
							botonHover[boton.name] = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
							boton.get_node("Play_sprites/Sprite").use_parent_material = false
							boton.position = Vector2(-157, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-2.857, -5)
							continue
					
					# reset valores segun boton
					match boton.name:
						"Quit":
							boton.position = Vector2(161.143, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, 3)
						"Options":
							boton.position = Vector2(-53, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(1.143, -5)
						"Play":
							boton.position = Vector2(-157, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-2.857, -5)
						"Discord":
							boton.position = Vector2(-237.857, -156)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-4, 4)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				# rotaciones
				var diferencia_x = abs(pos.x) - abs(boton.get_node("Play_sprites").global_position.x)
				var diferencia_y = abs(boton.get_node("Play_sprites").global_position.y) - abs(pos.y)
				match boton.name:
					"Quit":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", diferencia_x / 8)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y / 8)
					"Options":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x / 15)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y / 8)
					"Play":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x / 8)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y / 8)
					"Discord":
						boton.get_node("Play_sprites").material.set_shader_param("y_rot", -diferencia_x / 2)
						boton.get_node("Play_sprites").material.set_shader_param("x_rot", -diferencia_y / 2)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				boton.get_node("Play_sprites/Sprite").use_parent_material = false
				match boton.name:
					"Quit":
						boton.position = Vector2(161.143, 54)
						boton.get_node("Play_sprites/Shaw").position = Vector2(2, 3)
					"Options":
						boton.position = Vector2(-53, 54)
						boton.get_node("Play_sprites/Shaw").position = Vector2(1.143, -5)
					"Play":
						boton.position = Vector2(-157, 54)
						boton.get_node("Play_sprites/Shaw").position = Vector2(-2.857, -5)
					"Discord":
						boton.position = Vector2(-237.857, -156)
						boton.get_node("Play_sprites/Shaw").position = Vector2(-4, 4)
	
	
	if menu_actual == "select_partida":
		if Input.is_action_just_pressed("ui_cancel"):
			menu_actual = "default"
			#Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
			mover_suave(get_node("Seleccionar_partida/1"), Vector2(4.143, 405), 0.3)
			aprarecer_suave($Sprite, 0, 0.2)
		
		var menu = get_node("Seleccionar_partida/1/Menu")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible:
				continue
			
			var diffs = {
				"NEW":    Vector2(35, 20),
				"CONTINUE":    Vector2(50, 20),
			}
			
			var diferencia = diffs.get(boton.name, Vector2(40, 20))
			
			boton = botonPosision[boton.name]
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
			var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton = menu.get_child(i)
			
			if dentro:
				if boton.name == "NEW":
					if !Global.bandera_mouse:
						Global.bandera_mouse = true
				else:
					if boton.name == "CONTINUE":
						if encontro_partida_guardada:
							if !Global.bandera_mouse:
								Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton.name] = true
					match boton.name:
						"NEW":
							boton.position = Vector2(10, 369+4)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-0.762, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
						"CONTINUE":
							if encontro_partida_guardada:
								boton.position = Vector2(10, 419+4)
								boton.get_node("Play_sprites/Shaw").position = Vector2(-0.762, -8)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "NEW":
							Cargador.goto_scene("res://Scenas/Game.tscn")
						
						if boton.name == "CONTINUE":
							start_shake(get_node("Seleccionar_partida/1/Menu/CONTINUE/Candado"))
							if encontro_partida_guardada:
								Global.continuar = true
								Cargador.goto_scene("res://Scenas/Game.tscn")
								print("CONTINUE")
						
						
						
						if boton.name == "Play":
							#Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
							mover_suave(get_node("Seleccionar_partida/1"), Vector2(0,0), 0.3)
							aprarecer_suave($Sprite, 70, 0.2)
							menu_actual = "select_partida"
							botonHover[boton.name] = false
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
							boton.get_node("Play_sprites/Sprite").use_parent_material = false
							boton.position = Vector2(-157, 54)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-2.857, -5)
							continue
					
					# reset valores segun boton
					match boton.name:
						"NEW":
							boton.position = Vector2(10, 369)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -4)
						"CONTINUE":
							boton.position = Vector2(10, 419)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -4)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"NEW":
						boton.position = Vector2(10, 369)
						boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -4)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false
					"CONTINUE":
						boton.position = Vector2(10, 419)
						boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -4)
						
						if encontro_partida_guardada:
							boton.get_node("Play_sprites/Sprite").use_parent_material = false


func mover_suave(nodo: Node2D, nueva_pos: Vector2, duracion: float = 0.5) -> void:
	# Verificamos si el nodo ya tiene un Tween hijo
	var tween: Tween = nodo.get_node_or_null("TweenMover")
	if tween == null:
		tween = Tween.new()
		tween.name = "TweenMover"
		nodo.add_child(tween)
	
	# Cancelamos cualquier tween anterior
	var _a = tween.stop_all()
	
	# Interpolamos la posición con rebote y guardamos el retorno en _a
	_a = tween.interpolate_property(
		nodo, "position", nodo.position, nueva_pos,
		duracion, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	_a = tween.start()


func aprarecer_suave(nodo: Node2D, modulate, duracion: float = 0.5) -> void:
	# Verificamos si el nodo ya tiene un Tween hijo
	var tween: Tween = nodo.get_node_or_null("TweenModu")
	
	if tween == null:
		tween = Tween.new()
		tween.name = "TweenModu"
		nodo.add_child(tween)
	
	# Cancelamos cualquier tween anterior
	var _a = tween.stop_all()
	
	# Iniciamos la interpolación
	_a = tween.interpolate_property(
		nodo, "modulate:a8", nodo.modulate.a8, modulate,
		duracion, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	_a = tween.start()


var dragging := false
var dragged_letter = null
var offset_drag := Vector2()


func _unhandled_input(event):
	if menu_actual == "default":
		if letters.size() == 0:
			return
		
		var mid_index = letters.size() / 2
		var mid_letter = letters[int(mid_index)]
		var base_pos = mid_letter.get_meta("base_pos")
		
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				if event.pressed:
					# chequeamos si el mouse esta sobre la letra del medio
					var mouse_pos = get_global_mouse_position()
					if mid_letter.get_rect().has_point(mid_letter.to_local(mouse_pos)):
						dragging = true
						dragged_letter = mid_letter
						offset_drag = mid_letter.global_position - mouse_pos
				else:
					# soltar
					if dragging and dragged_letter:
						dragging = false
						# volver suavemente a la base
						mover_suave(dragged_letter, base_pos, 0.4)
						dragged_letter = null
		
		elif event is InputEventMouseMotion:
			if dragging and dragged_letter:
				var mouse_pos = get_global_mouse_position()
				dragged_letter.global_position = mouse_pos + offset_drag

