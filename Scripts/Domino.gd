extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Sprite-top").material = get_node("Sprite-top").material.duplicate()
	if Global.METODO_DE_CAIDA == "3d":
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 1)
	else:
		get_node("Sprite-top").material.set_shader_param("shadow_strength", 0)
