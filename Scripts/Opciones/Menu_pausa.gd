extends Node2D


var botonHover = {
	"Resume" : false,
	"Exit_menu" : false,
	"Exit_desk" : false
}


func _physics_process(_delta):
	if visible:
		for boton1 in $Botones.get_children():
			var boton = boton1.get_node("Sombra").rect_global_position
			boton += boton1.get_node("Sombra").rect_size/2
			boton.y -= 3
			
			var diferencia = Vector2(65, 20)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.x - diferencia.x and pos.x < boton.x + diferencia.x
			var dentro_y = pos.y > boton.y - diferencia.y and pos.y < boton.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton1.material.set_shader_param("to_color", Color("#346c53"))
			
			if dentro:
				Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton1.name] = true
					
					match boton1.name:
						"Resume":
							boton1.rect_position = Vector2(-64, -4 +4)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4-4)
							boton1.material.set_shader_param("to_color", Color("#28513e"))
						"Exit_menu":
							boton1.rect_position = Vector2(-64, 44 +4)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4-4)
							boton1.material.set_shader_param("to_color", Color("#28513e"))
						"Exit_desk":
							boton1.rect_position = Vector2(-64, 92 +4)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4-4)
							boton1.material.set_shader_param("to_color", Color("#28513e"))
				else:
					if botonHover[boton1.name]:
						shake_reroll()
						
						match boton1.name:
							"Resume":
								get_parent().get_parent().get_parent().ocultarse()
							"Exit_menu":
								Cargador.goto_scene("res://Scenas/menus/Menu Principal.tscn")
							"Exit_desk":
								get_tree().quit()
						
						botonHover[boton1.name] = false
					
					
					match boton1.name:
						"Resume":
							boton1.rect_position = Vector2(-64, -4)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4)
							boton1.material.set_shader_param("to_color", Color("#2d5d47"))
						"Exit_menu":
							boton1.rect_position = Vector2(-64, 44)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4)
							boton1.material.set_shader_param("to_color", Color("#2d5d47"))
						"Exit_desk":
							boton1.rect_position = Vector2(-64, 92)
							boton1.get_node("Sombra").rect_position = Vector2(0, 4)
							boton1.material.set_shader_param("to_color", Color("#2d5d47"))
			else:
				botonHover[boton1.name] = false
				
				match boton1.name:
					"Resume":
						boton1.rect_position = Vector2(-64, -4)
						boton1.get_node("Sombra").rect_position = Vector2(0, 4)
						boton1.material.set_shader_param("to_color", Color("#346c53"))
					"Exit_menu":
						boton1.rect_position = Vector2(-64, 44)
						boton1.get_node("Sombra").rect_position = Vector2(0, 4)
						boton1.material.set_shader_param("to_color", Color("#346c53"))
					"Exit_desk":
						boton1.rect_position = Vector2(-64, 92)
						boton1.get_node("Sombra").rect_position = Vector2(0, 4)
						boton1.material.set_shader_param("to_color", Color("#346c53"))


onready var camara = get_tree().get_nodes_in_group("camera")[0]


func shake_reroll():
	camara.rot_wave(2, 1, 0.2)
	camara.zoom_wave(2, 0.01, 0.2)
