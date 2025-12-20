extends Node2D


var botonHover = {
	"<_gen" : false,
	">_gen" : false,
	"b_gen" : false,
	"<_mus" : false,
	">_mus" : false,
	"b_mus" : false,
	"<_eff" : false,
	">_eff" : false,
	"b_eff" : false
}


func _physics_process(_delta):
	if visible and get_tree().paused:
		if Global.plata_mucha: $Botones/b_Mon/bit.bbcode_text = "[center][wave amp=13 freq=1]On [/wave][/center]" 
		else: $Botones/b_Mon/bit.bbcode_text = "[center][wave amp=13 freq=1]Off [/wave][/center]"
		
		if Global.bg_tienda: $Botones/b_bgt/bit.bbcode_text = "[center][wave amp=13 freq=1]On [/wave][/center]" 
		else: $Botones/b_bgt/bit.bbcode_text = "[center][wave amp=13 freq=1]Off [/wave][/center]"
		
		if Global.mover_camara: $Botones/b_MC/bit.bbcode_text = "[center][wave amp=13 freq=1]On [/wave][/center]" 
		else: $Botones/b_MC/bit.bbcode_text = "[center][wave amp=13 freq=1]Off [/wave][/center]"
		
		$"Botones/<_lang/Lang".bbcode_text = "[center][wave amp=13 freq=1]"+Global.idiomas[Global.idioma_actual]+" [/wave][/center]"
		
		for boton1 in $Botones.get_children():
			var boton
			if boton1.has_node("Sombra"):
				boton = boton1.get_node("Sombra").rect_global_position
			else:
				boton = boton1.rect_global_position
			
			if boton1.has_node("Sombra"):
				boton += boton1.get_node("Sombra").rect_size/2
			else:
				boton += boton1.rect_size/2
			
			boton.y -= 2
			
			var diferencia = Vector2(8, 8)
			
			var pos = get_global_mouse_position()
			var dentro_x = pos.x > boton.x - diferencia.x and pos.x < boton.x + diferencia.x
			var dentro_y = pos.y > boton.y - diferencia.y and pos.y < boton.y + diferencia.y
			var dentro = dentro_x and dentro_y
			
			boton1.material.set_shader_param("to_color", Color("#346c53"))
			
			if dentro:
				Global.bandera_mouse = true
				
				if Input.is_action_pressed("click"):
					botonHover[boton1.name] = true
					
					if boton1.has_node("Sombra"):
						boton1.get_node("Sombra").rect_position = Vector2(0, 2-2)
					boton1.material.set_shader_param("to_color", Color("#28513e"))
					
					match boton1.name:
						"<_lang":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.rect_position.y = -26.8 - 2
							
							boton1.rect_position.y = 94 + 2
						">_lang":
							boton1.rect_position.y = 94 + 2
				else:
					if botonHover[boton1.name]:
						shake_reroll()
						
						match boton1.name:
							"<_lang":
								Global.idioma_actual += -1
							">_lang":
								Global.idioma_actual += -1
							
							"b_MC":
								Global.mover_camara = !Global.mover_camara
							
							"b_Mon":
								Global.plata_mucha =  !Global.plata_mucha
							
							"b_bgt":
								Global.bg_tienda =  !Global.bg_tienda
						
						if Global.idioma_actual == -1:
							Global.idioma_actual = Global.idiomas.size()-1
						elif Global.idioma_actual == Global.idiomas.size():
							Global.idioma_actual = 0
						
						botonHover[boton1.name] = false
					
					if boton1.has_node("Sombra"):
						boton1.get_node("Sombra").rect_position = Vector2(0, 2)
					boton1.material.set_shader_param("to_color", Color("#2d5d47"))
					
					match boton1.name:
						"<_lang":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.rect_position.y = -26.8
							
							boton1.rect_position.y = 94
						">_lang":
							boton1.rect_position.y = 94
			else:
				botonHover[boton1.name] = false
				
				if boton1.has_node("Sombra"):
					boton1.get_node("Sombra").rect_position = Vector2(0, 2)
				boton1.material.set_shader_param("to_color", Color("#346c53"))
				
				match boton1.name:
					"<_lang":
						for i in boton1.get_children():
							if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
							i.rect_position.y = -26.8
						
						boton1.rect_position.y = 94
					">_lang":
						boton1.rect_position.y = 94


onready var camara = get_tree().get_nodes_in_group("camera")[0]


func shake_reroll():
	Global.sonido_boton()
	
	camara.rot_wave(2, 1, 0.2)
	camara.zoom_wave(2, 0.01, 0.2)
