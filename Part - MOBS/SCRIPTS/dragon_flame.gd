extends AnimatableBody2D


func anime(direction):
	if direction == "left":
		$AnimationPlayer.play("default")
	else:
		$Sprite2D.flip_h = true
		$AnimationPlayer.play("default")

func stop():
	$AnimationPlayer.stop()
	queue_free()
