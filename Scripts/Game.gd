extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}

var estaciones = {  "tienda" : -2000,
					"seleccion_nivel" : -1000,
					"nivel" : 0
}

var estacion_actual = "nivel"



func _ready():
	pass


func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	var posision = get_global_mouse_position()
	
	var camara = get_node("Viewport/Camera2D")
	camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
	$BackGround/Icon.position = (((posision-$BackGround/Icon.position)/40))
	$Viewport/Zona_de_interfaz.position.x = ((($Viewport/Zona_de_interfaz.position.x-posision.x)/100))-160
	$Viewport/Zona_de_interfaz.position.y = ((($Viewport/Zona_de_interfaz.position.y-posision.y)/100))
	$Viewport/Baraja.position.y = ((($Viewport/Baraja.position.y-posision.y)/300))+80
	$Viewport/Baraja.position.x = ((($Viewport/Baraja.position.x-posision.x)/300))+70
	
	
	var menu = get_node("Viewport/Menu")
	
	for i in range(menu.get_child_count()):
		var boton = menu.get_child(i)
		if !boton.visible:
			continue
		
		# diferencias por nombre
		var diffs = {
			"Delete": Vector2(14, 14)
		}
		
		var diferencia = diffs.get(boton.name, Vector2(40, 20))
		
		var pos = get_global_mouse_position()
		var dentro_x = pos.x > boton.global_position.x - diferencia.x and pos.x < boton.global_position.x + diferencia.x
		var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
		var dentro = dentro_x and dentro_y
		
		if dentro:
			# aca pones lo que ya tenias para hover/click de cada boton
			if Input.is_action_pressed("click"):
				botonHover[boton.name] = true
				# acciones de click segun el nombre
				match boton.name:
					"Delete":
						boton.position = Vector2(227.143, 60)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 0)
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.6)
			else:
				if botonHover[boton.name]:
					botonHover[boton.name] = false
					if boton.name == "Quit":
						get_tree().quit()
					if boton.name == "Play":
						Cargador.goto_scene("res://Scenas/menus/carrusel.tscn")
				
				# reset valores segun boton
				match boton.name:
					"Delete":
						boton.position = Vector2(227.143, 58)
						boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			
			# rotaciones
			var diferencia_x = abs(pos.x) - abs(boton.get_node("Play_sprites").global_position.x)
			var diferencia_y = abs(boton.get_node("Play_sprites").global_position.y) - abs(pos.y)
			match boton.name:
				"Delete":
					boton.get_node("Play_sprites").material.set_shader_param("y_rot", diferencia_x / 2)
					boton.get_node("Play_sprites").material.set_shader_param("x_rot", diferencia_y / 2)
			
			boton.get_node("Play_sprites/Sprite").use_parent_material = true
		else:
			botonHover[boton.name] = false
			boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			boton.get_node("Play_sprites/Sprite").use_parent_material = false
			match boton.name:
				"Delete":
					boton.position = Vector2(227.143, 58)
					boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)


