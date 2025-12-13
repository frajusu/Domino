extends Node2D


onready var bg = $BG
onready var label = $SD


var colores = {
	"plata":     Color("#b1911a"),
	"suma":      Color("#296e8f"),
	"especial":  Color("#a13895"),
	"especial_otro":  Color("#a13895"),
	"mult":      Color("#e0483e"),
	"null":      Color("#f3983a")
}

var ejecutandose = false


func _ready():
	set_as_toplevel(true)


func _physics_process(_delta):
	if Input.is_action_just_pressed("click") and get_tree().current_scene == self:
		# ejemplo: tiempo total 2 seg, porcentajes personalizados, velocidad 1.5x
		mostrar_tipo("especial", 1.2, 2.0, [20, 50, 40], 0.4, "God Stamp")


# porcentajes: array de 3 valores [entrada%, visible%, salida%], opcional
# velocidad: multiplica la duración total, 1.0 por defecto
func mostrar_tipo(tipo: String, numero: float, tiempo_total: float, porcentajes: Array = [null], velocidad: float = 1.0, stampa = "", sonido = "null"):
	ejecutandose = true
	
	#Global.reproducir_sonido ("punto", get_tree().get_nodes_in_group("camera")[0].global_position)
	match sonido:
		"especial":
			pass
		
		"mult":
			pass
		
		"plata":
			Global.reproducir_sonido("punto1",           get_tree().get_nodes_in_group("camera")[0].global_position)
			Global.reproducir_sonido("Comprar_vender",   get_tree().get_nodes_in_group("camera")[0].global_position)
			Global.reproducir_sonido("Comprar_vender_1", get_tree().get_nodes_in_group("camera")[0].global_position)
		
		"suma_domino":
			Global.reproducir_sonido("punto1",        get_tree().get_nodes_in_group("camera")[0].global_position)
			Global.reproducir_sonido("chips_place_1", get_tree().get_nodes_in_group("camera")[0].global_position)
			Global.reproducir_sonido("chips_place_2", get_tree().get_nodes_in_group("camera")[0].global_position)
	
	if tipo == "especial_suma": tipo = "especial"
	# setear porcentajes por defecto si no se pasan
	visible = true
	var p = porcentajes
	if p == [null]:
		p = [35, 30, 35]
	
	# setear color
	if colores.has(tipo):
		bg.modulate = colores[tipo]
	else:
		bg.modulate = Color.white
	
	# setear texto
	if tipo == "null":
		label.bbcode_text = "[center][wave amp=13 freq=1]\nnull\n[/wave][/center]"
	
	elif tipo == "mult":
		var num_str = ""
		if !(num_str.find(".") != -1):
			num_str += ".0"
		label.bbcode_text = "[center][wave amp=13 freq=1]\nx%s\n[/wave][/center]" %(str(numero)+num_str)
	
	elif tipo == "suma":
		label.bbcode_text = "[center][wave amp=13 freq=1]\n+%s\n[/wave][/center]" % str(numero)
	elif tipo == "especial":
		label.bbcode_text = "[center][wave amp=13 freq=1]\n+%s\n[/wave][/center]" % str(numero)
	elif tipo == "especial_otro":
		label.bbcode_text = "[center][wave amp=13 freq=1]\nx%s\n[/wave][/center]" % str(numero)
	elif tipo == "plata":
		label.bbcode_text = "[center][wave amp=13 freq=1]\n%sc\n[/wave][/center]" % str(numero)
	
	#print(label.bbcode_text)
	
	# resetear
	bg.scale = Vector2(0, 0)
	bg.modulate.a = 0
	bg.rotation_degrees = 0
	
	label.rect_scale = Vector2(0, 0)
	label.modulate.a = 0
	label.rect_rotation = 0
	
	if stampa != "":
		$stampa.region_rect.position = Diccionarios.stamps[stampa].position
		
		$stampa/AnimationPlayer.play("mover")
	
	# calcular duraciones ajustadas por velocidad
	var entrada_time = tiempo_total * p[0] / 100.0 * velocidad
	var visible_time = tiempo_total * p[1] / 100.0 * velocidad
	var salida_time  = tiempo_total * p[2] / 100.0 * velocidad
	
	# tween entrada BG
	var tween_bg = create_tween()
	tween_bg.tween_property(bg, "scale", Vector2(1.2, 1.2), entrada_time * 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_bg.tween_property(bg, "scale", Vector2(1, 1), entrada_time * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_bg.parallel().tween_property(bg, "rotation_degrees", 22, entrada_time * 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_bg.parallel().tween_property(bg, "modulate:a", 1.0, entrada_time * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_bg.tween_property(bg, "rotation_degrees", 0, entrada_time * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# tween entrada Label
	var tween_label = create_tween()
	tween_label.tween_property(label, "rect_scale", Vector2(1.2, 1.2), entrada_time * 0.6).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_label.tween_property(label, "rect_scale", Vector2(1, 1), entrada_time * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_label.parallel().tween_property(label, "rect_rotation", -22, entrada_time * 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_label.parallel().tween_property(label, "modulate:a", 1.0, entrada_time * 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_label.tween_property(label, "rect_rotation", 0, entrada_time * 0.4).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	
	# esperar visible_time antes de salida
	yield(get_tree().create_timer(visible_time), "timeout")
	
	# tween salida BG
	var tween_out_bg = create_tween()
	tween_out_bg.tween_property(bg, "scale", Vector2(0, 0), salida_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_out_bg.parallel().tween_property(bg, "rotation_degrees", -10, salida_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_out_bg.parallel().tween_property(bg, "modulate:a", 0.0, salida_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	# tween salida Label
	var tween_out_label = create_tween()
	tween_out_label.tween_property(label, "rect_scale", Vector2(0, 0), salida_time).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tween_out_label.parallel().tween_property(label, "rect_rotation", 10, salida_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween_out_label.parallel().tween_property(label, "modulate:a", 0.0, salida_time).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	tween_out_label.connect("finished", self, "_on_anim_finished")


func _on_anim_finished():
	ejecutandose = false
	#print("desaparecio")
	pass
