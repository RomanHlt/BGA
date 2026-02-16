extends Sprite2D

@export var heal : int = 1
@export var layer : int = 0

func _ready() -> void:
	$Area2D.collision_layer = 2**layer
	$Area2D.collision_mask = 2**layer


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body._heal(heal)
		$AnimationPlayer.play("PICK")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "PICK":
		queue_free()
