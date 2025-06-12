class_name InputComponent
extends Node2D

var input_horizontal :float = 0.0

func _process(delta: float) -> void:
	if not PlayerDataSaver.PlayerStats.is_dead:
		input_horizontal = Input.get_axis("move_left", "move_right")
		if input_horizontal > 0: input_horizontal=1
		elif input_horizontal < 0: input_horizontal = -1

func get_jump_input() -> bool:
	if PlayerDataSaver.PlayerStats.is_dead:
		return false
	return Input.is_action_just_pressed("jump")
	
func get_jump_input_released() -> bool:
	if PlayerDataSaver.PlayerStats.is_dead:
		return false
	return Input.is_action_just_released("jump")

func get_run() -> bool:
	if PlayerDataSaver.PlayerStats.is_dead:
		return false
	if PlayerDataSaver.SettingsStats.runAsToggle:
		return Input.is_action_just_pressed("run")
	return Input.is_action_pressed("run")

func get_fire() -> bool:
	if PlayerDataSaver.PlayerStats.is_dead:
		return false
	return Input.is_action_just_pressed("fire")
