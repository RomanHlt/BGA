extends Path2D

@export var speed_scale : float
@export var layer = 0
@export var loop = false

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var pos_x = $PathFollow2D.position[0]

func _ready() -> void:
	$AnimatableBody2D.collision_layer = 2**layer
	animation.play("Path")
	$"Animation graphique".play("Moving platform")
	animation.speed_scale = speed_scale


func _process(delta: float) -> void:
	if $PathFollow2D.position[0] <= pos_x:
		$"Animation graphique".play_backwards("Moving platform")
	else:
		$"Animation graphique".play("Moving platform")
	pos_x = $PathFollow2D.position[0]
	if loop:
		# Mode boucle : continue de suivre le chemin normalement
		path.progress_ratio += delta * speed_scale
		if path.progress_ratio >= 0.99:
			path.progress_ratio = 0  # Revient au début du chemin
	else:
		# Mode aller-retour
		path.progress_ratio += delta * speed_scale
		if path.progress_ratio >= 0.99:
			$AnimationPlayer.play_backwards("Path")
		if path.progress_ratio <= 0.01:
			$AnimationPlayer.play("Path")
			
	#pos_x = $PathFollow2D.position[0]
	
