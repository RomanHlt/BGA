extends PathFollow2D

var SPEED
var animatedSprite:AnimatedSprite2D
var is_sleeping : bool
var is_chasing: bool
var is_attacking:bool

func _ready() -> void:
	animatedSprite = _choose([$Zombie, $Root, $Fire, $Standart, $Vampire, $Albino])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()

func _process(delta: float) -> void:
	SPEED = get_parent().get_parent().SPEED
	is_sleeping = get_parent().get_parent().is_sleeping
	is_chasing = get_parent().get_parent().is_chasing
	is_attacking = get_parent().get_parent().is_attacking
	if !is_sleeping and !is_attacking and !is_chasing:
		progress_ratio += delta * (SPEED/100)
		animatedSprite.play("flying")

func _choose(array):
	array.shuffle()
	return array.front()
