extends Node2D


var ejecutandose = false

onready var botonPosision =  {  "Play"                  : {"global_position" : Vector2(230, -129)},
								"Draw"                  : {"global_position" : get_parent().get_node("Viewport/Menu/Draw").global_position},
								"Deck"                  : {"global_position" : get_parent().get_node("Viewport/Menu/Deck").global_position},
								"Delete"                : {"global_position" : get_parent().get_node("Viewport/Menu/Delete").global_position},
								"Delete1"               : {"global_position" : get_parent().get_node("Viewport/Zona_de_tienda/Menu/Delete1").global_position + Vector2(-5.5, 1)},
								"GO"                    : {"global_position" : Vector2(-785.057007, 118)},
								"GO1"                   : {"global_position" : Vector2(1214.943115, 118)},
								"Skip"                  : {"global_position" : Vector2(1202, 109)},
								"Buy"                   : {"global_position" : Vector2(1078.143066, -58)},
								"Reroll_Normal"         : {"global_position" : Vector2(800, 15)},
								"Reroll_Charms"         : {"global_position" : Vector2(1215, 25)},
								"Reroll_Specials"       : {"global_position" : Vector2(922, 32)},
}

var botonHover =   {"Play"              : false,
					"Deck"              : false,
					"Draw"              : false,
					"GO"                : false,
					"GO1"               : false,
					"Skip"              : false,
					"Buy"               : false,
					"Reroll_Normal"     : false,
					"Reroll_Charms"     : false,
					"Reroll_Specials"   : false,
					"Delete"            : false,
					"Delete1"           : false,
					"Options"           : false,
					"Quit"              : false,
					"Discord"           : false,
}

var siguiente = 1

var bandera_go_seleccion = false




func reproducir_siguiente_tuto(actual : String):
	$Select/impares.play(actual)
	siguiente = int(actual)+1
	ejecutandose = true


func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen") and get_tree().paused:
		OS.window_fullscreen = !OS.window_fullscreen
	
	
	if Input.is_action_just_pressed("click"):
		if get_tree().paused:
			if siguiente != 7 and siguiente != 8:
				if ejecutandose:
					var ap = $Select/impares
					ap.seek(ap.current_animation_length, true) # ir al ultimo frame
					ap.stop() # dispara animation_finished
					ejecutandose = false
				else:
					reproducir_siguiente_tuto(str(siguiente))
		else:
			if siguiente > 8:
				if ejecutandose:
					var ap = $Select/impares
					ap.seek(ap.current_animation_length, true) # ir al ultimo frame
					ap.stop() # dispara animation_finished
					ejecutandose = false
				else:
					reproducir_siguiente_tuto(str(siguiente))
	
	
	if siguiente == 8 and !get_tree().paused:
		Global.bandera_mouse = false
		
		var botones = [$"Select/opciones/botones/1", $"Select/opciones/botones/2"]
		
		for boton in botones:
			var pos = get_global_mouse_position()
			var diferencia = Vector2(72, 17)
			var dentro_x = pos.x > boton.rect_global_position.x and pos.x < boton.rect_global_position.x + diferencia.x
			var dentro_y = pos.y > boton.rect_global_position.y and pos.y < boton.rect_global_position.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			if dentro:
				Global.bandera_mouse = true
				
				if Input.is_action_just_pressed("click"):
					reproducir_siguiente_tuto(str(siguiente))
	
	
	if get_tree().paused:
		Global.bandera_mouse = false
		
		if get_parent().estacion_actual == "seleccion_nivel" and bandera_go_seleccion:
			var menu = get_parent().get_node("Viewport/Zona_de_interfaz/Select/Menu/1")
			
			for i in range(menu.get_child_count()):
				var boton = menu.get_child(i)
				if !boton.visible or boton.name == "fondo":
					continue
				
				var diffs = {
					"GO":    Vector2(35, 20),
				}
				
				var diferencia = diffs.get(boton.name, Vector2(40, 20))
				
				boton = botonPosision[boton.name]
				
				var pos = get_global_mouse_position()
				var dentro_x = pos.x > boton.global_position.x - diferencia.x-2 and pos.x < boton.global_position.x + diferencia.x-2
				var dentro_y = pos.y > boton.global_position.y - diferencia.y and pos.y < boton.global_position.y + diferencia.y
				var dentro = dentro_x and dentro_y
				
				boton = menu.get_child(i)
				
				if dentro:
					if !Global.bandera_mouse:
						Global.bandera_mouse = true
					
					if Input.is_action_pressed("click"):
						botonHover[boton.name] = true
						match boton.name:
							"GO":
								boton.position = Vector2(-19.8+0.8, -11.25+0.8)
								boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
								boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
					else:
						if botonHover[boton.name]:
							botonHover[boton.name] = false
							if boton.name == "GO":
								reproducir_siguiente_tuto(str(siguiente))
								get_tree().paused = false
								get_parent().cambiar_estacion()
								get_parent().shake_go()
						
						# reset valores segun boton
						match boton.name:
							"GO":
								boton.position = Vector2(-19.8, -11.25)
								boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
						
						boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					
					boton.get_node("Play_sprites/Sprite").use_parent_material = true
				else:
					botonHover[boton.name] = false
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
					match boton.name:
						"GO":
							boton.position = Vector2(-19.8, -11.25)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
							boton.get_node("Play_sprites/Sprite").use_parent_material = false


func _on_impares_animation_finished(_anim_name):
	ejecutandose = false


func set_bandera(valor):
	bandera_go_seleccion = valor
