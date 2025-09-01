extends Node2D

var modo = false
var velocidad = 0

func _ready():
	visible = true


func _physics_process(_delta):
	var viewport_zize = get_tree().root.get_viewport().size
	
	if viewport_zize.x == 0 and viewport_zize.y != 0:
		$Tex_mira.scale = (Vector2(0 , 1152/viewport_zize.y))/2
	else:
		if viewport_zize.y == 0 and viewport_zize.x != 0:
			$Tex_mira.scale = (Vector2(2048/viewport_zize.x , 0))/2
		else:
			if viewport_zize.y == 0 and viewport_zize.x == 0:
				$Tex_mira.scale = (Vector2(0 , 0))/2
			else:
				$Tex_mira.scale = (Vector2(2048/viewport_zize.x , 1152/viewport_zize.y))/2
	
	if modo == true:
		$Rotador.look_at(get_global_mouse_position())
		
		var x = get_global_mouse_position().x*get_global_mouse_position().x
		var y = get_global_mouse_position().y*get_global_mouse_position().y
		
		var h = sqrt(x+y)
		
		$Rotador/Posision_mira.position.x = h
		
		$Tex_mira.global_position = $Rotador/Posision_mira.global_position
	else:
		$Tex_mira.global_position = get_global_mouse_position()
	
	Global.posision_de_la_mira = $Tex_mira.position


func _input(event):
	if event is InputEventMouseMotion:
		velocidad = event.relative.x

