class_name InputComponent
extends Node2D

var input_horizontal :float = 0.0

func _process(delta: float) -> void:
	input_horizontal = Input.get_axis("move_left", "move_right")

func get_jump_input() -> bool:
	return Input.is_action_just_pressed("jump")
