extends CharacterBody2D


const SPEED = 100.0
@export var direction:int = -1

func _physics_process(delta: float) -> void:

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is Player:
		body.velocity.x += direction*600
		body.velocity.y -=400 
		queue_free()


func _on_area_2d_2_body_entered(body: Node2D) -> void:
	if body is Player:
		queue_free()
