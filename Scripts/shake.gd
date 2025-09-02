extends Camera2D

var shake_duration : float = 0
var shake_magnitude : float = 0

onready var posision = position

var random = RandomNumberGenerator.new()

func shake(duration: float, magnitude: float, _asd= "asd"):
	if !(shake_duration > 0):
		shake_duration = duration
		shake_magnitude = magnitude


func _physics_process(delta: float):
	if shake_duration > 0:
		randomize()
		position.x += rand_range(-shake_magnitude, shake_magnitude)
		position.y += rand_range(-shake_magnitude, shake_magnitude)
	
		shake_duration -= delta
	elif position != posision:
		position = posision

func _ready():
	pass
	#shake(0.5, 10)
