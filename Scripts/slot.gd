extends Sprite


var hijo = null

onready var scale_original = self.scale.x

onready var posision_original = self.position.x

func _ready():
	if !get_parent().get_parent().yo.flechitas.has(name):
		queue_free()
