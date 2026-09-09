extends Area2D

@export var skewValue := 15
@export var bendGrassnimationSpeed = 0.3
@export var grassReturnAnimationSpeed = 5.0

func _ready() -> void:
	collision_mask = 2**abs(get_parent().z_index)

func _on_body_entered(body: Node2D) -> void:
	if (body is Player):
		var direction = global_position.direction_to(body.global_position)
		var skew : int = -direction.x * skewValue
		
		var tween = create_tween()
		tween.tween_property(
			$Sprite2D.material,
			"shader_parameter/skew",
			skew,
			bendGrassnimationSpeed
			).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
		
		tween.tween_property(
			$Sprite2D.material,
			"shader_parameter/skew",
			0.0,
			grassReturnAnimationSpeed
			).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
		
