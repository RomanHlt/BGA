extends PathFollow2D

var SPEED
var animatedSprite:AnimatedSprite2D
var is_sleeping : bool
var is_chasing: bool
var is_attacking:bool
var dead :bool

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
	dead = get_parent().get_parent().dead
	if !is_sleeping and !is_attacking and !is_chasing and !dead:
		progress_ratio += delta * (SPEED/100)
		animatedSprite.play("flying")
	if is_chasing:
			animatedSprite.play("flying")
	elif is_attacking:
			animatedSprite.play("attack")
	elif !dead and is_sleeping :
		animatedSprite.play("sleeping")

func _choose(array):
	array.shuffle()
	return array.front()
