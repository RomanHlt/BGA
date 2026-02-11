extends RigidBody2D


var in_explosion = false
var target : CharacterBody2D


func explode():
	# Animation d'explosion
	if in_explosion:
		target._takeDamages(1)
	self.queue_free() # Mettre dans animation finished


func _on_explosion_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		in_explosion = true
		target = body

func _on_explosion_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		in_explosion = false


func _on_activation_zone_body_entered(body: Node2D) -> void:
	if body != self and body.name != "Boss":
		explode()
