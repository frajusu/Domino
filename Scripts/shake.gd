extends Camera2D

var shake_time := 0.0
var shake_strength := 0.0
var shake_dir := Vector2.ZERO
var original_pos := Vector2.ZERO

var zoom_target := Vector2.ONE
var zoom_speed := 5.0
var original_zoom := Vector2.ONE

var zoom_wave_time := 0.0
var zoom_wave_strength := 0.0
var zoom_wave_count := 0
var zoom_wave_duration := 0.0
var zoom_wave_total_time := 0.0

var shake_wave_active := false
var shake_wave_strength := 0.0
var shake_wave_count := 0
var shake_wave_duration := 0.0
var shake_wave_total_time := 0.0
var shake_wave_dir := Vector2.ZERO

onready var rng := RandomNumberGenerator.new()

# --- VARIABLES NUEVAS ---
var rot_wave_active := false
var rot_wave_strength := 0.0
var rot_wave_count := 0
var rot_wave_duration := 0.0
var rot_wave_total_time := 0.0
var original_rot := 0.0


func _ready():
	original_pos = position
	original_zoom = zoom
	original_rot = rotation
	zoom_target = zoom
	rng.randomize()


# --- ROTACION ONDULANTE ---
# Ej: rot_wave(5, 10, 1.5)
# → 5 oscilaciones, 10 grados de amplitud, 1.5 seg de duracion total
func rot_wave(waves: int, degrees_strength: float, duration: float):
	rot_wave_count = waves
	rot_wave_strength = deg2rad(degrees_strength)
	rot_wave_duration = duration
	rot_wave_total_time = 0.0
	rot_wave_active = true


# --- ZOOM SUAVE ---
func set_zoom_target(mult: float):
	zoom_target = original_zoom * mult


# --- ZOOM ONDULANTE ---
# Ej: zoom_wave(3, 0.1, 1.5)
# → 3 ondulaciones, 0.1 de intensidad, 1.5 seg de duracion total
func zoom_wave(waves: int, strength: float, duration: float):
	zoom_wave_count = waves
	zoom_wave_strength = strength
	zoom_wave_duration = duration
	zoom_wave_total_time = 0.0


# --- SACUDIDA ONDULANTE ---
# Ej: shake_wave(3, 20, 1, "izq")
# → 3 ondulaciones, 20 px de fuerza, 1 seg total, hacia la izquierda
func shake_wave(waves: int, strength: float, duration: float, dir: String = "libre"):
	shake_wave_count = waves
	shake_wave_strength = strength
	shake_wave_duration = duration
	shake_wave_total_time = 0.0
	shake_wave_active = true
	
	match dir:
		"izq":
			shake_wave_dir = Vector2(-1, 0)
		"der":
			shake_wave_dir = Vector2(1, 0)
		"arriba":
			shake_wave_dir = Vector2(0, -1)
		"abajo":
			shake_wave_dir = Vector2(0, 1)
		_:
			shake_wave_dir = Vector2(1, 0) # por defecto, horizontal


func _physics_process(delta):
	if get_tree().root.has_node("Game"):
		if get_tree().paused:
			var Icon  = get_parent().get_parent().get_node("GameBG")
			var Icon1 = get_parent().get_parent().get_node("TiendaBG")
			var posision = get_global_mouse_position()
			var camara = get_parent()
			var estacion_actual = get_parent().get_parent().get_parent().estacion_actual
			var estaciones = get_parent().get_parent().get_parent().estaciones
			#var estacion_aux = get_parent().get_parent().get_parent().estacion_aux
			var otro = get_parent().get_node("Black")
			
			if Global.mover_camara:
				camara.position = (((posision-camara.position)/40)) + Vector2(estaciones[estacion_actual], 0)
				Icon.position =   (((posision-Icon.position)/40))   + Vector2(estaciones[estacion_actual], 0)
				Icon1.position =  (((posision-Icon1.position)/40))  + Vector2(estaciones[estacion_actual], 0)
				otro.position =  -((((posision-Vector2(estaciones[estacion_actual], 0))-otro.position)/20))
	
	elif get_tree().root.has_node("Menu_Principal"):
		if get_tree().root.get_node("Menu_Principal/Black/Black").visible:
			var posision = get_global_mouse_position()
			
			var camara = self
			camara.position = (((posision-camara.position)/40))
	
	
	# --- Suavizado del zoom manual ---
	zoom = lerp(zoom, zoom_target, delta * zoom_speed)
	
	# --- Zoom ondulante ---
	if zoom_wave_count > 0:
		zoom_wave_total_time += delta
		var progress = zoom_wave_total_time / zoom_wave_duration
		if progress >= 1.0:
			zoom_wave_count = 0
			zoom = original_zoom
		else:
			var wave = sin(progress * PI * zoom_wave_count)
			zoom = original_zoom * (1.0 + wave * zoom_wave_strength)

	# --- Shake ondulante ---
	if shake_wave_active:
		shake_wave_total_time += delta
		var progress = shake_wave_total_time / shake_wave_duration
		if progress >= 1.0:
			shake_wave_active = false
			position = original_pos
		else:
			var wave = sin(progress * PI * shake_wave_count)
			position = original_pos + shake_wave_dir.normalized() * wave * shake_wave_strength

	# --- Shake aleatorio ---
	elif shake_time > 0:
		shake_time -= delta
		var intensity = shake_strength * (shake_time / max(shake_time, 0.001))
		
		var offset = Vector2(
			rng.randf_range(-1, 1) * intensity,
			rng.randf_range(-1, 1) * intensity
		)
		
		if shake_dir != Vector2.ZERO:
			offset = shake_dir.normalized() * rng.randf_range(-intensity, intensity)
		
		position = original_pos + offset
	else:
		position = lerp(position, original_pos, delta * 10)
	
	# --- Rotacion ondulante ---
	if rot_wave_active:
		rot_wave_total_time += delta
		var progress = rot_wave_total_time / rot_wave_duration
		
		if progress >= 1.0:
			rot_wave_active = false
			if get_tree().root.has_node("Game"):
				get_tree().root.get_node("Game").rotation = original_rot
				get_tree().root.get_node("Game/Viewport/Camera2D/camara").rotation = -original_rot
			elif get_tree().root.has_node("Menu_Principal"):
				get_tree().root.get_node("Menu_Principal").rotation = original_rot
				get_tree().root.get_node("Menu_Principal/Viewport/camara").rotation = -original_rot
		else:
			# Movimiento suave y con amortiguación
			var t = progress * PI * rot_wave_count
			var damping = pow(1.0 - progress, 0.5)
			var wave = sin(t) * damping
			
			var nueva_rot = original_rot + wave * rot_wave_strength
			
			if get_tree().root.has_node("Game"):
				get_tree().root.get_node("Game").rotation = nueva_rot
				get_tree().root.get_node("Game/Viewport/Camera2D/camara").rotation = -nueva_rot
			elif get_tree().root.has_node("Menu_Principal"):
				get_tree().root.get_node("Menu_Principal").rotation = nueva_rot
				get_tree().root.get_node("Menu_Principal/Viewport/camara").rotation = -nueva_rot



# --- SACUDIDA NORMAL ---
func shake(duration: float, strength: float, dir: String = "libre"):
	shake_time = duration
	shake_strength = strength
	
	match dir:
		"izq":
			shake_dir = Vector2(-1, 0)
		"der":
			shake_dir = Vector2(1, 0)
		"arriba":
			shake_dir = Vector2(0, -1)
		"abajo":
			shake_dir = Vector2(0, 1)
		_:
			shake_dir = Vector2.ZERO
