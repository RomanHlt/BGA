class_name AnimationComponent
extends Node2D
signal awaken

@export_subgroup("Nodes")
@export var animator: AnimationPlayer
@export var sprite: Sprite2D
var stuned:bool = false
func _ready() -> void:
	animator.get_animation("DASH").loop_mode = Animation.LOOP_NONE #rendre DASH unique
	animator.get_animation("Trumpet").loop_mode = Animation.LOOP_NONE #rendre DASH unique
	animator.get_animation("DEATH").loop_mode = Animation.LOOP_NONE
	animator.get_animation("Stuned").loop_mode = Animation.LOOP_NONE
	animator.get_animation("WakeUp").loop_mode = Animation.LOOP_NONE

	
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
	if get_parent().behindLeft and get_parent().behindRight and not get_parent().canGoCloser:
		get_parent().get_node("Sprite2D").self_modulate = "00000056"
	else:
		get_parent().get_node("Sprite2D").self_modulate = "ffffff"
	
	if !stuned:
		handle_horizontal_flip(move_direction)
		if PlayerDataSaver.PlayerStats.is_dead:
			animator.play("DEATH")
		elif get_parent().fire and body.canMove:
			animator.play("Trumpet")
		elif get_parent().layerJump:
			animator.speed_scale = 4
			if get_parent().canGoCloser: 
				animator.play("DASH")
		else:
			if move_direction !=0 and body.is_on_floor() and body.canMove:                                                                     
				animator.play("RUN")
			else:
				animator.play("IDLE")
				
			if body.velocity.y != 0:
					if body.velocity.y < 0:
						animator.play("JUMP")
					else:
						animator.play("FALL")   

func get_stuned():
	stuned = true
	animator.play("Stuned")
func end_stun():
	animator.play("WakeUp")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "DASH":
		get_parent().layerJump = false
		animator.speed_scale = 1
	if anim_name == "Trumpet":
		get_parent().fire = false
	if anim_name == "DEATH":
		animator.get_parent().hide()
	if anim_name == "Stuned":
		animator.play("StunIdle")
	if anim_name == "WakeUp":
		stuned = false
		animator.play("IDLE")
		awaken.emit()
