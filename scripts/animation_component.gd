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
	
func handle_move_animation(body:CharacterBody2D, move_direction:float)->void:
	handle_horizontal_flip(move_direction)
	
	if move_direction !=0 and body.is_on_floor():                                                                         
		animator.play("RUN")
	else:
		animator.play("IDLE")
		
	if body.velocity.y != 0:
			if body.velocity.y < 0:
				animator.play("JUMP")
			else:
				animator.play("FALL")   
