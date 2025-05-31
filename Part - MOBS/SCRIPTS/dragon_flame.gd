extends AnimatableBody2D

@onready var player_in = false

func _ready() -> void:
	collision_mask = 2**get_parent().layer
	collision_layer = 0


func anime(direction):
	if direction == "left":
		$AnimationPlayer.play("default")
	else:
		$Sprite2D.flip_h = true
		$AnimationPlayer.play("default")

func stop():
	$AnimationPlayer.stop()
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		player_in = true
		while player_in:
			body._takeDamages(1)
			await get_tree().create_timer(1).timeout
		
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		player_in = false
