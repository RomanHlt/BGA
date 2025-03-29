extends Path2D


@export var loop = true # Vrai si le path fait une boucle, faux sinon
@export var speed_scale = 1.0
@export var layer = 0
@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatableBody2D.collision_layer = 2**layer
	if not loop:
		animation.play("Moving platform")
		animation.speed_scale = speed_scale
		set_process(false)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
