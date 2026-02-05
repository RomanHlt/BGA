extends RigidBody2D

@export var layer = 0
var is_broken = false

func _ready() -> void:
	$AnimationPlayer.speed_scale = 2
	collision_layer = 2**layer
	collision_mask = 2**layer
	$Area2D.collision_mask = 2**layer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if is_broken:
		return

	if body.name == "Player":
		body._takeDamages(1)

	is_broken = true
	set_deferred("freeze", true)
	collision_layer = 0
	collision_mask = 0
	$Area2D.collision_mask = 0
	$AnimationPlayer.play("Break")

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	queue_free()
