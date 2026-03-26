extends Path2D
class_name MovingPlatform

@export var speed := 0.05          # tours par seconde
@export var initialPos_px: int = 0
@export var layer := 0
@export var loop := true           # true = boucle, false = ping-pong

@onready var path: PathFollow2D = $PathFollow2D

var direction := 1.0

func _ready() -> void:
	path.progress = initialPos_px
	path.loop = loop

	$AnimatableBody2D.collision_layer = 2 ** layer
	$AnimatableBody2D/Area2D.collision_mask = 2 ** layer
	$AnimatableBody2D/AnimationGraphique.play("action")

	set_process(true)


func _process(delta: float) -> void:
	if loop:
		# boucle infinie
		path.progress_ratio += speed * delta
	else:
		# aller-retour (ping-pong)
		path.progress_ratio += direction * speed * delta

		if path.progress_ratio >= 1.0:
			path.progress_ratio = 1.0
			direction = -1.0
		elif path.progress_ratio <= 0.0:
			path.progress_ratio = 0.0
			direction = 1.0


# Traversable par dessous
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatableBody2D.collision_layer = 0


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$AnimatableBody2D.collision_layer = 2 ** layer


func reset(pos = initialPos_px) -> void:
	path.progress = pos
	direction = 1.0
