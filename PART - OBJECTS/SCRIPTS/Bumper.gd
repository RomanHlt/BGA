extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.speed_scale = 3
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and !body.is_on_floor():
		$AnimationPlayer.play("Bump")
		#body.get_node("AdvancedJumpComponent").is_jumping = true
		body.velocity.y = -1000


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Bump":
		$AnimationPlayer.play("IDLE")
