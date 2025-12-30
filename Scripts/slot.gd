extends Sprite


var hijo = null

onready var scale_original = self.scale.x

onready var posision_original = self.position.x

func _ready():
	var abuelo = get_parent().get_parent()
	if not (abuelo is Viewport) and !abuelo.yo.flechitas.has(name):
		queue_free()
