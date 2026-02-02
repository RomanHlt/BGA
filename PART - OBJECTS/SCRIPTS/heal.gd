extends AnimatableBody2D

@export var heal : int = 1
@export var layer : int = 0

func _ready() -> void:
	$AnimationPlayer.play("heal")
	$Area2D.collision_layer = 2**layer
	$Area2D.collision_mask = 2**layer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body._heal(heal)
		$AudioStreamPlayer.play()


func _on_audio_stream_player_finished() -> void:
	self.hide()
	await get_tree().create_timer(30).timeout
	self.show()
