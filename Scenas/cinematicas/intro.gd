extends Node2D


onready var label = $Viewport/Descripcion

export var destino = ""

var rng = RandomNumberGenerator.new()

var ejecutandose = true


var deseos = ["""[wave amp=50 freq=2] G
 Hey G's here.
 Soooo, what is your wish going to be, I'm pretty curious about it.
			  
 You
 My wish...                                              
 I want to be inmortal.                      
									
 G
 So so so lame.
[/wave]""",


"""[wave amp=50 freq=2] G
 Hey bro.
 Please tell me your wish I'm really curious about it.
			  
 You
 My wish...                                              
 I want an umbrella.                      
									
 G
 what
[/wave]""",


"""[wave amp=50 freq=2] G
 Oh its you again.
 Back so soon?
			  
 You
 Yeah...
 I thought about it a lot.
											  
 I want infinite money.                      
									
 G
 Wow.
 Truly original.
[/wave]""",


"""[wave amp=50 freq=2] G
 Ok.
 Your wish.
 Try not to disappoint me.
			  
 You
 I wish...
											  
 I wish everyone clapped when I enter a room.                      
									
 G
 Every room?
			  
 You
 Bathrooms too.
[/wave]""",


"""[wave amp=50 freq=2] G
 So.
 Whats the wish.
			  
 You
 I want a button.
											  
 G
 A button?
									
 You
 Yeah.
 One that does something cool.
			  
 G
 Like what.
									
 You
 I dont know.
 Thats the fun part.
[/wave]""",
]





func _ready():
	if get_tree().current_scene.name == "intro":
		$Viewport/Descripcion.bbcode_text = """[wave amp=50 freq=2]
 You encounter a genie, and with your sweet talk convice him to 
 give you a wish.             
 Even though you didn't find the magic lamp.
					  
 But he gives one condition, you have to play a game.
			
 """+str(Global.nivel_gandor)+""" levels,
								
		
 Are you ready?
 
[/wave]"""
	
	
	if get_tree().current_scene.name == "win":
		rng.randomize()
		
		$Viewport/Genie.visible = true
		
		$Viewport/Descripcion.bbcode_text = deseos[rng.randi_range(0, deseos.size()-1)]
		#$Viewport/Descripcion.bbcode_text = deseos[deseos.size()-1]
	
	
	yield(get_tree().create_timer(1.0), "timeout")
	mostrar_texto()


var timer_post_texto = null
var timer_activo = false


func _physics_process(_delta):
	if !ejecutandose:
		label.visible_characters = 2500
	
	if Input.is_action_just_pressed("click"):
		if ejecutandose:
			ejecutandose = false
			label.visible_characters = 2500
		else:
			if destino == "game":
				Cargador.goto_scene("res://Scenas/Game.tscn")
			if destino == "menu":
				Cargador.goto_scene("res://Scenas/menus/Menu Principal.tscn")
	
	if Input.is_action_just_pressed("fullscreen"):
		OS.window_fullscreen = !OS.window_fullscreen


func mostrar_texto():
	if !ejecutandose: label.visible_characters = 0
	
	while label.visible_characters < label.get_total_character_count():
		if !ejecutandose: break
		label.visible_characters += 1
		yield(get_tree().create_timer(0.04), "timeout")
	
	
	
	ejecutandose = false
