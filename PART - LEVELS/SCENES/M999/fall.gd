extends Area2D

var target : CharacterBody2D


func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body

func _process(delta: float) -> void:
	if target:
		target.velocity.y = 200
		target.position.x = 0
