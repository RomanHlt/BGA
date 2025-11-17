extends Path2D

@export var speed_scale : float
@export var layer = 0
@export var loop = false
@export var break_time : float = 0.0

@onready var path = $PathFollow2D
@onready var animation = $AnimationPlayer
@onready var pos_x = $PathFollow2D.position[0]
@onready var on_break = false
@onready var direction = 1

func _ready() -> void:
	$AnimatableBody2D.collision_layer = 2**layer
	animation.play("Path")
	$"Animation graphique".play("Moving platform")
	animation.speed_scale = speed_scale


func _process(delta: float) -> void:
	if on_break:
		pass
	else:
		if $PathFollow2D.position[0] <= pos_x:
			$"Animation graphique".play_backwards("Moving platform")
		else:
			$"Animation graphique".play("Moving platform")
		pos_x = $PathFollow2D.position[0]
		
		path.progress_ratio += delta * speed_scale * direction
		
		if loop:
			# Mode boucle : continue de suivre le chemin normalement
			if path.progress_ratio >= 0.999:
				path.progress_ratio = 0  # Revient au début du chemin
				take_a_break()
		else:
			# Mode aller-retour
			if path.progress_ratio >= 0.99:
				direction = -1
				path.progress_ratio = 0.98
				take_a_break()
				
			if path.progress_ratio <= 0.01:
				direction = 1
				path.progress_ratio = 0.02
				take_a_break()
				
		#pos_x = $PathFollow2D.position[0]
	
func take_a_break():
	on_break = true
	await get_tree().create_timer(break_time).timeout
	on_break = false

	
