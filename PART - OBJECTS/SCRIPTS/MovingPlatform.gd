extends Path2D
class_name MovingPlatform

@export var loop = true
@export var speed = 1.0
@export var initialPos_px : int = 0
@export var layer = 0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer

func _ready() -> void:
	path.progress = initialPos_px
	$AnimatableBody2D.collision_layer = 2 ** layer
	$AnimatableBody2D/Area2D.collision_mask = 2 ** layer
	$AnimatableBody2D/AnimaionGraphique.play("action")

	if not loop:
		animation.play("move")
		animation.speed_scale = speed
	else:
		animation.get_animation("move").loop_mode = Animation.LOOP_LINEAR # On force le mode "boucle" sur l'animation "move"
		animation.play("move")
		animation.speed_scale = speed

	set_process(false) # plus besoin de _process, tout passe par l'AnimationPlayer


# Traversable par dessous
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatableBody2D.collision_layer = 0

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatableBody2D.collision_layer = 2 ** layer

func reset(pos = initialPos_px):
	path.progress = pos
	animation.stop()
	animation.play("move")
