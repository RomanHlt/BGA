class_name AnimationComponent
extends Node2D

@export_subgroup("Nodes")
@export var animator: AnimationPlayer
@export var sprite: Sprite2D
func handle_horizontal_flip(move_direction: float) -> void:
	if move_direction == 0:
		return
	if move_direction > 0:
		sprite.flip_h = false
		sprite.offset.x = 0
	else: 
		sprite.flip_h = true
		sprite.offset.x = 4
	
func handle_move_animation(move_direction:float)->void:
	handle_horizontal_flip(move_direction)
	
	if move_direction !=0:
		animator.play("RUN")
	else:
		animator.play("IDLE")
