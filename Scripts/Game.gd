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

var nivel_actual = 1

var actualizado = false

onready var camara = get_node("Viewport/Camera2D")
var estacion_actual = "seleccion_nivel"

var domino_a_borrar = null

var semilla

var estacion_aux


func _ready():
	randomize()
	semilla = randi()
	seed(semilla)
	print(semilla)
	estacion_aux = estacion_actual
	estacion_actual = "transicion"
	
	get_node("Viewport/1").position.x = estaciones[estacion_aux]


func puntos_por_nivel(nivel: int) -> int:
	if nivel <= 0:
		return 0
	
	var base := 80           # puntos del nivel 1
	var crecimiento := 1.15  # factor de crecimiento
	var variacion := 10      # variación aleatoria para que no sea exacto
	
	# fórmula: base * crecimiento^(nivel-1) + variación aleatoria
	var puntos = base * pow(crecimiento, nivel - 1)
	puntos += randi() % variacion
	return int(round(puntos))


func _physics_process(_delta):
	if estacion_actual == "transicion":
		#get_node("Viewport/Zona_de_interfaz/Select/1").position.y = lerp(get_node("Viewport/Zona_de_interfaz/Select/1").position.y, 15, 0.1)
		var nodo = get_node("Viewport/Zona_de_interfaz/Select/1")
		
		var tween: Tween = nodo.get_node_or_null("TweenMover")
		
		if tween == null:
			tween = Tween.new()
			tween.name = "TweenMover"
			nodo.add_child(tween)
		
		# Cancelamos cualquier tween anterior
		var _a = tween.stop_all()
		
		# Interpolamos la posición con rebote y guardamos el retorno en _a
		_a = tween.interpolate_property(
			nodo, "position:y", nodo.position.y, 15,
			0.5, Tween.TRANS_BACK, Tween.EASE_OUT, 0.9
		)
		_a = tween.start()
		
		estacion_actual = "seleccion_nivel"
	
	
	if estacion_actual == "seleccion_nivel" and !actualizado:
		actualizar_escenario_seleccion_nivel()
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen
	
	if Input.is_action_just_pressed("cambiar"):
		cambiar_estacion()
	
	var posision = get_global_mouse_position()
	
	if !hay_tween_activo():
		if estacion_actual == "transicion":
			if Global.mover_camara:
				$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_aux], 0)
				camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_aux], 0)
			else:
				camara.position = Vector2(estaciones[estacion_aux], 0)
				$Viewport/Icon.position = Vector2(estaciones[estacion_aux], 0)
		else:
			if Global.mover_camara:
				$Viewport/Icon.position = (((posision-$Viewport/Icon.position)/40)) + Vector2(estaciones[estacion_actual], 0)
				camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
			else:
				camara.position = Vector2(estaciones[estacion_actual], 0)
				$Viewport/Icon.position = Vector2(estaciones[estacion_actual], 0)
	
	var menu = get_node("Viewport/Menu")
	
	for i in range(menu.get_child_count()):
		var boton = menu.get_child(i)
		if !boton.visible:
			continue
		
		# diferencias por nombre
		var diffs = {
			"Delete": Vector2(23, 14)
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
						if $Viewport/Baraja.dragging:
							domino_a_borrar = $Viewport/Baraja.dragging
							domino_a_borrar.scale.x = 0.1
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
						if domino_a_borrar:
							$Viewport/Baraja.last_hovered_card = null
							$Viewport/Baraja.arrastrado = null
							$Viewport/Baraja.dragging = null
							domino_a_borrar.queue_free()
							domino_a_borrar = null
				
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			
			boton.get_node("Play_sprites/Sprite").use_parent_material = true
		else:
			botonHover[boton.name] = false
			boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
			boton.get_node("Play_sprites/Sprite").use_parent_material = false
			match boton.name:
				"Delete":
					boton.position = Vector2(227.143, 58)
					boton.get_node("Play_sprites/Shaw").position = Vector2(0, 4)
					domino_a_borrar = null
	
	
	if estacion_actual == "seleccion_nivel":
		menu = get_node("Viewport/Zona_de_interfaz/Select/Menu")
		for i in range(menu.get_child_count()):
			var boton = menu.get_child(i)
			if !boton.visible or boton.name == "1":
				continue
			
			var diffs = {
				"GO":    Vector2(35, 20),
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
					match boton.name:
						"GO":
							boton.position = Vector2(210+3, 127+3)
							boton.get_node("Play_sprites/Shaw").position = Vector2(-1, -8)
							boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.4)
				else:
					if botonHover[boton.name]:
						botonHover[boton.name] = false
						if boton.name == "GO":
							cambiar_estacion()
					
					# reset valores segun boton
					match boton.name:
						"GO":
							boton.position = Vector2(210, 127)
							boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
					
					boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				
				boton.get_node("Play_sprites/Sprite").use_parent_material = true
			else:
				botonHover[boton.name] = false
				boton.get_node("Play_sprites").material.set_shader_param("flash_modifier", 0.197)
				match boton.name:
					"GO":
						boton.position = Vector2(210, 127)
						boton.get_node("Play_sprites/Shaw").position = Vector2(2, -5)
						boton.get_node("Play_sprites/Sprite").use_parent_material = false


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
		
		camara.position.x = get_node("Viewport/1").position.x
		
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
		tween.interpolate_property(
			get_node("Viewport/1"), "position:x",
			get_node("Viewport/1").position.x, 2000,
			0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		
		tween.start()
		
		tween.connect("tween_all_completed", self, "_on_tween_wrap", [estacion_actual], CONNECT_ONESHOT)
		return
	
	_tween_to(estaciones[estacion_actual])


func _on_tween_wrap(e: String) -> void:
	camara.position.x = -2000
	get_node("Viewport/1").position.x = -2000
	$Viewport/Icon.position.x = -2000
	
	estacion_actual = e
	_tween_to(estaciones[e])


func _tween_to(destino: float) -> void:
	var tween = get_node("Tween") if has_node("Tween") else null
	if tween == null:
		tween = Tween.new()
		add_child(tween)
	tween.stop_all()
	
	camara.position.x = get_node("Viewport/1").position.x
	
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
	tween.interpolate_property(
		get_node("Viewport/1"), "position:x",
		get_node("Viewport/1").position.x, destino,
		0.4, Tween.TRANS_SINE, Tween.EASE_IN_OUT
	)
	tween.start()


func hay_tween_activo() -> bool:
	for child in get_children():
		if child is Tween and child.is_active():
			return true
	return false


func actualizar_escenario_seleccion_nivel():
	get_node("Viewport/Zona_de_interfaz/Select/1/Level/Num").bbcode_text = "[center]\n"+str(nivel_actual)+"\n[/center]"
	get_node("Viewport/Zona_de_interfaz/Select/1/Points").bbcode_text = "[center][wave amp=50 freq=2]\n"+str(puntos_por_nivel(nivel_actual))+"\n[/wave][/center]"
	actualizado = true
