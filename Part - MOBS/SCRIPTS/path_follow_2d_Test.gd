extends PathFollow2D

var SPEED
var animatedSprite:AnimatedSprite2D
var is_sleeping : bool
var is_chasing: bool
var is_attacking:bool
var dead :bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animatedSprite = get_parent().animatedSprite
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != animatedSprite.name:
			child.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	SPEED = get_parent().SPEED
	is_sleeping = get_parent().is_sleeping
	is_chasing = get_parent().is_chasing
	is_attacking = get_parent().is_attacking
	dead = get_parent().dead
	if !is_sleeping and !is_attacking and !is_chasing and !dead:
		progress_ratio += delta * (SPEED/100)
		animatedSprite.play("flying")
