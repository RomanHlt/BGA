extends Area2D




func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.global_position = $Marker2D.global_position
		body.velocity.y = 0
