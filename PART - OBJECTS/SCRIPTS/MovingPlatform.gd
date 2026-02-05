extends Path2D

@export var loop = true
@export var speed_loop = 2.0
@export var speed = 1.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatableBody2D/AnimaionGraphique.play("action")
	if not loop:
		animation.play("move")
		animation.speed_scale = speed
		set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	path.progress += speed_loop
