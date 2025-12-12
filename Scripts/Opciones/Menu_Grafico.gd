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
	if visible:
		var blanco        = Color("#ffffff")        # color cuando el pixel está ON
		var default_color = Color("#234737") # tu color por defecto
		
		var botones_stats = {
			$Botones.get_node("<_vig")   : Global.grafico.vignete_opacity,
			$Botones.get_node("<_noise") : Global.grafico.noise / 0.1,
		}
		
		if OS.window_fullscreen: $Botones/b_FS/bit.bbcode_text = "[center][wave amp=13 freq=1]On [/wave][/center]" 
		else: $Botones/b_FS/bit.bbcode_text = "[center][wave amp=13 freq=1]Off [/wave][/center]"
		
		for boton in botones_stats.keys():
			var vol = botones_stats[boton]
			var total_pix = 11
			var pix_a_colorear = int(round(vol * total_pix))
			
			var i := 0
			
			for pixel in boton.get_children():
				if pixel.name == "Sombra" or pixel.name == ">=<2" or pixel.name == ">=<":
					continue
				
				if i < pix_a_colorear:
					pixel.get_node("sw").material.set_shader_param("forced_color", blanco)
				else:
					pixel.get_node("sw").material.set_shader_param("forced_color", default_color)
				
				i += 1
		
		
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
						"<_vig":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.position.y = 7 - 2
							
							boton1.rect_position.y = 53 + 2
						">_vig":
							boton1.rect_position.y = 53 + 2
						
						"<_noise":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.position.y = 7 - 2
							
							boton1.rect_position.y = 102 + 2
						">_noise":
							boton1.rect_position.y = 102 + 2
				else:
					if botonHover[boton1.name]:
						shake_reroll()
						
						# cuanto cambia por clic (1 / 11)
						var paso = 1.0 / 11.0
						var paso_noise = 0.1 / 11.0
						
						match boton1.name:
							"<_vig":
								Global.grafico.vignete_opacity = clamp(Global.grafico.vignete_opacity - paso, 0.0, 1.0)
							">_vig":
								Global.grafico.vignete_opacity = clamp(Global.grafico.vignete_opacity + paso, 0.0, 1.0)
							
							"<_noise":
								Global.grafico.noise = clamp(Global.grafico.noise - paso_noise, 0.0, 0.1)
							">_noise":
								Global.grafico.noise = clamp(Global.grafico.noise + paso_noise, 0.0, 0.1)
							
							"b_FS":
								OS.window_fullscreen = !OS.window_fullscreen
						
						botonHover[boton1.name] = false
					
					if boton1.has_node("Sombra"):
						boton1.get_node("Sombra").rect_position = Vector2(0, 2)
					boton1.material.set_shader_param("to_color", Color("#2d5d47"))
					
					match boton1.name:
						"<_vig":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.position.y = 7
							
							boton1.rect_position.y = 53
						">_vig":
							boton1.rect_position.y = 53
						
						"<_noise":
							for i in boton1.get_children():
								if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
								i.position.y = 7
							
							boton1.rect_position.y = 102
						">_noise":
							boton1.rect_position.y = 102
			else:
				botonHover[boton1.name] = false
				
				if boton1.has_node("Sombra"):
					boton1.get_node("Sombra").rect_position = Vector2(0, 2)
				boton1.material.set_shader_param("to_color", Color("#346c53"))
				
				match boton1.name:
					"<_vig":
						for i in boton1.get_children():
							if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
							i.position.y = 7
						
						boton1.rect_position.y = 53
					">_vig":
						boton1.rect_position.y = 53
					
					"<_noise":
						for i in boton1.get_children():
							if i.name == "Sombra" or i.name == ">=<2" or i.name == ">=<": continue
							i.position.y = 7
						
						boton1.rect_position.y = 102
					">_noise":
						boton1.rect_position.y = 102


onready var camara = get_tree().get_nodes_in_group("camera")[0]


func shake_reroll():
	Global.sonido_boton()
	
	camara.rot_wave(2, 1, 0.2)
	camara.zoom_wave(2, 0.01, 0.2)
