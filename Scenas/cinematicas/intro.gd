extends Node2D


onready var label = $Viewport/Descripcion

export var destino = ""

var ejecutandose = false


func _ready():
	ejecutandose = true
	
	label.visible_characters = 0
	
	yield(get_tree().create_timer(2.0), "timeout")
	mostrar_texto()


func _physics_process(_delta):
	if Input.is_action_just_pressed("click"):
		if ejecutandose:
			ejecutandose = false
			label.visible_characters = -1
		else:
			if destino == "game":
				Cargador.goto_scene("res://Scenas/Game.tscn")
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func mostrar_texto():
	label.visible_characters = 0
	
	while label.visible_characters < label.get_total_character_count():
		if !ejecutandose: break
		label.visible_characters += 1
		yield(get_tree().create_timer(0.04), "timeout")
	
	ejecutandose = false

