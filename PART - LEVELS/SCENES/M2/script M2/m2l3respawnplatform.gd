extends Area2D


@export var path : Path2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		get_tree().current_scene.findRightSpawn()
		path.reset(0)
		path.animation.stop()
		path.animation.play("move")
