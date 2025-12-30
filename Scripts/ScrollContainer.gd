extends ScrollContainer

export(float) var suavizado := 0.15
export(float) var rebote := 0.25 # control de corrección al llegar al límite
export(float) var friccion := 0.9
export(float) var multiplicador_rueda := 40.0
export(float) var max_overshoot := 100.0

var velocidad := 0.0
var offset_y := 0.0
var contenido : Control = null


func _ready():
	get_parent().visible = true
	
	set_process(true)
	
	# buscamos el hijo que no sea scroll bar
	for c in get_children():
		if c is Control and not (c is VScrollBar or c is HScrollBar):
			contenido = c
			break
	
	if not contenido:
		printerr("ScrollContainer necesita un hijo tipo Control (VBox, Grid, MarginContainer, etc.)")


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			velocidad -= multiplicador_rueda
		elif event.button_index == BUTTON_WHEEL_DOWN:
			velocidad += multiplicador_rueda


func _physics_process(delta):
	if name == "scroll_stats":
		var game = get_tree().root.get_node("Game")
		
		if game.baraja_activa == "Deck" or game.baraja_activa == "Deck1":
			if game.menu_actual != "STATS":
				return
		else:
			return
	
	if not contenido:
		return
	
	var alto_total = contenido.rect_size.y
	var alto_vista = rect_size.y
	var max_scroll = max(0, alto_total - alto_vista)
	
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
