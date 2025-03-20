extends RigidBody2D

@export var speed:int = 200
@export var area:Area2D 

func _physics_process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_area_2d_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.name != "Player":
		if body.name == "frog":
			body._death()
		queue_free()
