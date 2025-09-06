extends Node2D


var botonHover =   {"Play" : false,
					"Options" : false,
					"Quit" : false,
					"Discord" : false,
}

var estaciones = {  "seleccion_nivel" : -1000,
					"tienda" : 1000,
					"nivel" : 0
}

onready var camara = get_node("Viewport/Camera2D")
var estacion_actual = "tienda"



func _ready():
	pass


func cambiar_estacion() -> void:
	match estacion_actual:
		"seleccion_nivel":
			estacion_actual = "nivel"
		"tienda":
			estacion_actual = "seleccion_nivel"
		"nivel":
			estacion_actual = "tienda"
	
	
	if estacion_actual == "seleccion_nivel":
		var tween = get_node("Tween") if has_node("Tween") else null
		if tween == null:
			tween = Tween.new()
			add_child(tween)
		tween.stop_all()
		
		tween.interpolate_property(
			camara, "position:x",
			camara.position.x, 2000,
			0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			$Viewport/Icon, "position:x",
			$Viewport/Icon.position.x, 2000,
			0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		
		tween.start()
		
		tween.connect("tween_all_completed", self, "_on_tween_wrap", [estacion_actual], CONNECT_ONESHOT)
		return
	
	_tween_to(estaciones[estacion_actual])


func _on_tween_wrap(e: String) -> void:
	camara.position.x = -2000
	$Viewport/Icon.position.x = -2000
	
	estacion_actual = e
	_tween_to(estaciones[e])


func _tween_to(destino: float) -> void:
	var tween = get_node("Tween") if has_node("Tween") else null
	if tween == null:
		tween = Tween.new()
		add_child(tween)
	tween.stop_all()
	
	tween.interpolate_property(
		camara, "position:x",
		camara.position.x, destino,
		0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		$Viewport/Icon, "position:x",
		$Viewport/Icon.position.x, destino,
		0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.start()


func hay_tween_activo() -> bool:
	for child in camara.get_children():
		if child is Tween and child.is_active():
			return true
	return false


func _physics_process(_delta):
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("click"):
		cambiar_estacion()
	
	var posision = get_global_mouse_position()
	
	if !hay_tween_activo():
		camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
		$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_actual], 0)

	
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


