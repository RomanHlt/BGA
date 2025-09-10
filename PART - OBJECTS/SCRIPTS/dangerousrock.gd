extends CharacterBody2D

@export var layer = 0
var is_broken = false

func _ready() -> void:
	collision_layer = 2**layer
	$Area2D.collision_mask = 2**layer

func _process(delta: float) -> void:
	if is_broken:
		velocity.y = 0
	else:
		$GravityComponent.handle_gravity(self, delta)
		velocity.y = min(velocity.y, 300)
		move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body._takeDamages(1)
	is_broken = true
	collision_layer = 0
	$Area2D.collision_mask = 0
	$AnimationPlayer.play("Break")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	self.queue_free()
