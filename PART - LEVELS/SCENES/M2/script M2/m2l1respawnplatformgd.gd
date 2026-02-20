extends Area2D

@export var moving : Path2D

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		moving.reset(-2000)
