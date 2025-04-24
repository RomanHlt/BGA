extends PathFollow2D

var SPEED
var sprites

func _ready() -> void:
	sprites = get_parent().get_parent().animatedSprite

func _process(delta: float) -> void:
	SPEED = get_parent().get_parent().SPEED
	progress_ratio += delta * (SPEED/100)
