extends Node2D

class_name Fallingrock

@export_category("Self settings")
@export var layer : int
@onready var inrock = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fondu/AnimatableBody2D.collision_layer = 2**layer
	$Fondu/AnimatableBody2D.collision_mask = 2**layer
	$Fondu/AnimatableBody2D/above.collision_layer = 2**layer
	$Fondu/AnimatableBody2D/above.collision_mask = 2**layer
	$Fondu/AnimatableBody2D/inrock.collision_layer = 2**layer
	$Fondu/AnimatableBody2D/inrock.collision_mask = 2**layer


func _on_above_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		break_rock()


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Break broke broken":
		$Fondu/FonduPlayer.play("fondu", -1, 0)
		$Fondu/FonduPlayer.seek(0, true)
		$Fondu/AnimationPlayer.seek(0, true)
		await get_tree().create_timer(5).timeout	# Temps avant de remettre le rocher
		while inrock:
			await get_tree().create_timer(1).timeout
		$Fondu/AnimatableBody2D.collision_layer = 2**layer
		$Fondu/FonduPlayer.play("fondu")
		$Fondu/AnimatableBody2D/above.collision_mask = 2**layer

func break_rock():
	$Fondu/AnimationPlayer.play("Break broke broken")
	await get_tree().create_timer(0.6).timeout
	$Fondu/AnimatableBody2D.collision_layer = 0
	$Fondu/AnimatableBody2D/above.collision_mask = 0


func _on_inrock_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inrock = true


func _on_inrock_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inrock = false
