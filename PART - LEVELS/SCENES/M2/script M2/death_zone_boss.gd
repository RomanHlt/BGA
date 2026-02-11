extends Area2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body._takeDamages(100)
	else:
		body.queue_free()
