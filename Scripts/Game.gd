extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}


var domino = preload("res://Scenas/Domino.tscn")

var mazo = {
	
}

var dragging = null
var arrastrado = null
var offset = Vector2(0,0)
var target_pos = {}
var return_to_pos = false  # indica que debe volver suavemente

onready var drop_zone_sprite = $Viewport/GameArea

var mouse_over = false  # variable que indica si el mouse está encima


func _ready():
	# Crear varios sprites para arrastrar
	for i in range(3):
		var s = domino.instance()
		s.position = Vector2(50 + i*70, 50)
		$Viewport/Baraja.add_child(s)
	
	var _a = $Viewport/GameArea/Area2D.connect("mouse_entered", self, "_on_mouse_entered")
	_a = $Viewport/GameArea/Area2D.connect("mouse_exited", self, "_on_mouse_exited")

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false


var divisor_distancia = 2


func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	
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
		
		if boton.visible != false:
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
	
	
	if return_to_pos and arrastrado:
		# Velocidad constante, ajusta 500 a lo rápido que quieres que vaya
		var velocidad = 500 
		arrastrado.global_position = arrastrado.global_position.move_toward(target_pos[arrastrado], velocidad * _delta)
		
		if arrastrado.global_position.distance_to(target_pos[arrastrado]) < 5:
			arrastrado.global_position = target_pos[arrastrado]
			return_to_pos = false
			arrastrado = null
	
	for s in $Viewport/Baraja.get_children():
		s.get_node("Sprite-top/Flechita").rotation_degrees = s.get_node("Sprite-top").material.get_shader_param("r1") * 180 / PI
	
	var mouse_pos = get_global_mouse_position()
	var radio : float

	for s in $Viewport/Baraja.get_children():
		var centro : Vector2
		if s.get_node("Sprite").visible:
			centro = s.global_position
			radio = max(s.get_node("Sprite").texture.get_size().x, s.get_node("Sprite").texture.get_size().y) / 2
		else:
			centro = s.global_position
			radio = max(s.get_node("detector").texture.get_size().x, s.get_node("detector").texture.get_size().y) / (2 * divisor_distancia)

		# Verificamos si el mouse está dentro del "círculo" del sprite
		if mouse_pos.distance_to(centro) <= radio:
			s.get_node("Sprite-top/Flechita/Flechita2").visible = true
			# Apagar todos los demás
			for s1 in $Viewport/Baraja.get_children():
				if s1 != s:
					s1.get_node("Sprite-top/Flechita/Flechita2").visible = false
			break
		else:
			s.get_node("Sprite-top/Flechita/Flechita2").visible = false


func _input(event):
	# Click y rueda del mouse
	if event is InputEventMouseButton:
		# Click izquierdo
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				var mouse_pos = get_global_mouse_position()
				
				for s in $Viewport/Baraja.get_children():
					if s != arrastrado:
						var centro : Vector2
						var radio : float
						
						if s.get_node("Sprite").visible:
							centro = s.global_position
							radio = max(s.get_node("Sprite").texture.get_size().x, s.get_node("Sprite").texture.get_size().y) / 2
						else:
							centro = s.global_position
							radio = max(s.get_node("detector").texture.get_size().x, s.get_node("detector").texture.get_size().y) / (2 * divisor_distancia)

						# Verificamos si el mouse está dentro del "círculo" del sprite
						if mouse_pos.distance_to(centro) <= radio:
							dragging = s
							if s.get_node("Sprite").visible:
								target_pos[s] = s.global_position
							return_to_pos = false
							break

			else:
				if dragging:
					if dragging.get_node("Sprite").visible:
						return_to_pos = true
						arrastrado = dragging
					dragging = null
		
		# Rueda del mouse
		elif dragging and !dragging.get_node("Sprite").visible:
			if event.button_index == BUTTON_WHEEL_DOWN and event.is_pressed():
				dragging.get_node("Sprite-top").material.set_shader_param(
					"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") + 0.25
				)
			elif event.button_index == BUTTON_WHEEL_UP and event.is_pressed():
				dragging.get_node("Sprite-top").material.set_shader_param(
					"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") - 0.25
				)
		
	# Teclas opcionales para rotar sin rueda
	elif event is InputEventKey and dragging and event.is_pressed() and !dragging.get_node("Sprite").visible:
		if event.scancode == KEY_LEFT or event.scancode == KEY_A:
			dragging.get_node("Sprite-top").material.set_shader_param(
				"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") - 0.25
			)
		elif event.scancode == KEY_RIGHT or event.scancode == KEY_D:
			dragging.get_node("Sprite-top").material.set_shader_param(
				"r1", dragging.get_node("Sprite-top").material.get_shader_param("r1") + 0.25
			)
		
	elif event is InputEventMouseMotion and dragging:
		dragging.global_position = get_global_mouse_position() + offset
		dragging.get_node("Sprite").visible = !is_over_drop_zone()

		# --- REPULSION ENTRE ELEMENTOS ---
		if !dragging.get_node("Sprite").visible:
			for s in $Viewport/Baraja.get_children():
				if s == dragging:
					continue
				if !s.get_node("Sprite").visible:
					var dir = dragging.global_position - s.global_position
					var dist = dir.length()
					
					var distancia_de_repelerse = 15
					
					if dist < distancia_de_repelerse:  # distancia mínima de repulsión
						dir = dir.normalized()
						dragging.global_position += dir * (distancia_de_repelerse - dist) * 1
				
		# --- COLOR Y SHADER ---
		var base_color = get_average_color(dragging.get_node("Sprite").texture)
		dragging.get_node("Sprite-top").material.set_shader_param("original_color", base_color)
		
		var dark_factor = 0.5
		var darker_color = Color(
			base_color.r * dark_factor,
			base_color.g * dark_factor,
			base_color.b * dark_factor,
			base_color.a
		)
		dragging.get_node("Sprite-top").material.set_shader_param("shadow_color", darker_color)
		



func finish_dragging(s):
	s.global_position = s.global_position.linear_interpolate(target_pos[s], 10)


# ahora tu función
func is_over_drop_zone():
	return mouse_over


func get_average_color(tex:Texture):
		var img = tex.get_data()
		img.lock()
		var col = Color(0,0,0)
		var count = 0
		for x in range(img.get_width()):
			for y in range(img.get_height()):
				col += img.get_pixel(x,y)
				count += 1
		img.unlock()
		return col / count
