extends Node2D


var modulate_target = 80

var duracion = 0.2

var menu_actual = 1

var amuletos_a_invocar = Diccionarios.amuletos.keys()

var amuletos_bloqueados = []


func mostrarse():
	nivel_max = Global.leer_save("Partida", "Nivel_Maximo", 0)
	
	for i in amuletos_a_invocar:
		crear_amuleto(i)
	
	for i in amuletos_bloqueados:
		crear_amuleto(i, true)
	
	
	amuletos_a_invocar.clear()
	
	
	$Black.visible = true
	while $Black.self_modulate.a8 < modulate_target:
		yield(get_tree(), "idle_frame")
		$Black.self_modulate.a8 += 20
	
	$Black.self_modulate.a8 = modulate_target
	
	# --- TRANS_BACK manual ---
	var menu = $Menu_info
	var inicio_y = menu.rect_position.y
	var final_y = -114
	
	var tiempo = 0.0
	var s = 1.70158
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# TRANS_BACK + EASE_OUT
		t -= 1
		var suav = (t * t * ((s + 1) * t + s) + 1)
		
		menu.rect_position.y = lerp(inicio_y, final_y, suav)
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	menu.rect_position.y = final_y


func ocultarse():
	while $Black.self_modulate.a8 > 0:
		yield(get_tree(), "idle_frame")
		$Black.self_modulate.a8 -= 20
	
	$Black.visible = false
	$Black.self_modulate.a8 = 0
	
	
	# --- TRANS_BACK manual ---
	var menu = $Menu_info
	var inicio_y = menu.rect_position.y
	var final_y = 230
	var tiempo = 0.0
	var s = 1.70158
	
	while tiempo < duracion:
		var t = tiempo / duracion
		
		# TRANS_BACK + EASE_IN
		var suav = t * t * ((s + 1) * t - s)
		
		menu.rect_position.y = lerp(inicio_y, final_y, suav)
		
		yield(get_tree(), "idle_frame")
		tiempo += get_process_delta_time()
	
	menu.rect_position.y = final_y
	
	$Black.visible = false
	
	get_tree().paused = false


func _physics_process(_delta):
	if Input.is_action_just_pressed("ui_cancel") and $Black.visible == true and $Black.self_modulate.a8 == modulate_target:
		ocultarse()
	
	
	if get_tree().paused == true and $Black.visible == true:
		Global.pause_mode = Node.PAUSE_MODE_PROCESS
		
		Global.bandera_mouse = false
		
		if Input.is_action_just_pressed("fullscreen"):
			OS.window_fullscreen = !OS.window_fullscreen


var amuletos_instancia = preload("res://Scenas/Amuletos_de_menu.tscn")
var amuletos_instancia_no_desbloqueado = preload("res://Scenas/Amuletos_de_menu_principal.tscn")

var nivel_max = Global.leer_save("Partida", "Nivel_Maximo", 0)


func crear_amuleto(amuleto, bloqueados = false):
	if !bloqueados:
		if nivel_max < Diccionarios.amuletos[amuleto]["nivel_desbloqueo"]:
			amuletos_bloqueados.append(amuleto)
			return
	
	if amuleto == "borrar": return
	
	var grid =  $Menu_info/Zona_de_amuletos/Baraja_S/ScrollContainer/MarginContainer/GridContainer
	
	var data = Diccionarios.amuletos[amuleto]
	
	var desbloqueado = nivel_max >= data["nivel_desbloqueo"]
	
	var s
	
	if desbloqueado:
		s = amuletos_instancia.instance()
	else:
		s = amuletos_instancia_no_desbloqueado.instance()
	
	s.name = amuleto
	s.get_node("Sprite").region_rect.position = data["position"]
	s.get_node("Sprite").region_rect.size = data["size"]
	#s.rect_global_position = Vector2(208, 0)
	
	s.set_meta("base_pos", s.get_node("Sprite").position)
	
	# Configurar labels
	if desbloqueado:
		var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
		var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
		var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
		
		for label in [titulo_label, desc_label, costo_label]:
			label.bbcode_enabled = true
		
		titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["titulo"]))
		desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["descripcion"]))
		costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["venta"])) + "[color=#b1911a]" + Global.prefix_plata
	else:
		var titulo_label = s.get_node("Descripcion/MarginContainer/Titulo/Label")
		var desc_label   = s.get_node("Descripcion/MarginContainer/Descripcion/Label")
		var costo_label  = s.get_node("Descripcion/MarginContainer/Costo/Label")
		
		for label in [titulo_label, desc_label, costo_label]:
			label.bbcode_enabled = true
		
		titulo_label.bbcode_text = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode("Locked"))
		desc_label.bbcode_text   = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode("Unknown"))
		costo_label.bbcode_text  = "[center]%s[/center]" % Text.parsear_colores_bbcode1(Text.parsear_colores_bbcode(data["venta"])) + "[color=#b1911a]" + Global.prefix_plata
	
	
	grid.add_child(s)


