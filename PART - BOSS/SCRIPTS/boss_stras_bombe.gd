extends RigidBody2D


var in_explosion = false
var target : CharacterBody2D
var is_explosing = false

func _ready() -> void:
	$AnimationPlayer.play("idle")

func explode():
	if is_explosing:
		return
	is_explosing = true
	if in_explosion:
		target._takeDamages(1)
	$AnimationPlayer.play("Explosion")


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


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.queue_free() # Mettre dans animation finished
