extends Node2D


export var max_scale = 1.2
export var max_rotation_degrees = 15.0
var oscillations = 1
var animation_duration = 0.6
var animation_speed = 3
var is_animating = false
var animation_timer = 0.0
var original_scale = Vector2()
var original_rotation = 0.0


func _ready():
	original_scale = scale
	original_rotation = rotation


func start_animation():
	is_animating = true
	animation_timer = animation_duration


func _physics_process(delta):
	if is_animating:
		animation_timer -= delta * animation_speed
		if animation_timer > 0:
			var t = 1.0 - (animation_timer / animation_duration)
			
			scale = original_scale.linear_interpolate(Vector2(max_scale, max_scale), sin(t * PI))
			
			var oscillation_factor = sin(t * oscillations * PI * 2)
			rotation = original_rotation + oscillation_factor * deg2rad(max_rotation_degrees)
		else:
			scale = original_scale
			rotation = original_rotation
			is_animating = false
