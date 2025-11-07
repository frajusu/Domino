extends ScrollContainer

export(float) var suavizado := 0.15
export(float) var rebote := 0.25 # control de corrección al llegar al límite
export(float) var friccion := 0.9
export(float) var multiplicador_rueda := 40.0
export(float) var max_overshoot := 100.0

var velocidad := 0.0
var offset_y := 0.0
var arrastrando := false
var arrastre_prev_y := 0.0
var contenido : Control = null


func _ready():
	set_process(true)
	mouse_filter = MOUSE_FILTER_STOP
	
	# buscamos el hijo que no sea scroll bar
	for c in get_children():
		if c is Control and not (c is VScrollBar or c is HScrollBar):
			contenido = c
			break
	
	if not contenido:
		printerr("⚠ ScrollContainer necesita un hijo tipo Control (VBox, Grid, MarginContainer, etc.)")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			velocidad -= multiplicador_rueda
		elif event.button_index == BUTTON_WHEEL_DOWN:
			velocidad += multiplicador_rueda
		elif event.button_index == BUTTON_LEFT:
			if event.pressed:
				# solo activar arrastre si el mouse está sobre el scrollcontainer
				var pos_local = get_local_mouse_position()
				if Rect2(Vector2.ZERO, rect_size).has_point(pos_local):
					arrastrando = true
					arrastre_prev_y = get_global_mouse_position().y
			else:
				arrastrando = false

	elif event is InputEventMouseMotion and arrastrando:
		var delta_y = get_global_mouse_position().y - arrastre_prev_y
		arrastre_prev_y = get_global_mouse_position().y
		offset_y -= delta_y
		velocidad = -delta_y * 10


func _process(delta):
	if not contenido:
		return
	
	var alto_total = contenido.rect_size.y
	var alto_vista = rect_size.y
	var max_scroll = max(0, alto_total - alto_vista)
	
	if arrastrando:
		offset_y = clamp(offset_y, -max_overshoot, max_scroll + max_overshoot)
	else:
		offset_y += velocidad * delta
		velocidad *= pow(friccion, delta * 60)
		
		if offset_y < 0:
			offset_y = lerp(offset_y, 0.0, rebote)
			velocidad = 0
		elif offset_y > max_scroll:
			offset_y = lerp(offset_y, max_scroll, rebote)
			velocidad = 0
		
		offset_y = clamp(offset_y, -max_overshoot, max_scroll + max_overshoot)
	
	contenido.rect_position.y = -offset_y
