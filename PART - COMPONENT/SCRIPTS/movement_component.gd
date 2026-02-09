class_name MovementComponent
extends Node2D

@export_subgroup("Settings")
@export var speed: float = 100
@export var runningSpeed: float = 250
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0
@export var dashForce:float = 600

var dash:bool = false

func handle_horizontal_movement(body:CharacterBody2D, direction:float, isRunning:bool,canMove:bool) ->void:
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	if canMove:
		if !dash:
			body.velocity.x = move_toward(body.velocity.x, direction * choose_right_speed(isRunning), velocity_change_speed)
		else:
			body.velocity.y = 0
	else:
		body.velocity.x = move_toward(body.velocity.x,0,velocity_change_speed)
func handle_dash(body:CharacterBody2D,flipH:bool,onDash:bool):
	if onDash and PlayerDataSaver.PlayerStats.dashUnlocked and $DashTimer.is_stopped():
		dash = true
		InGame.reloadDash()
		$DashTimer.start()
		if flipH:
			body.velocity.x = -dashForce
		else:
			body.velocity.x = dashForce
		body.velocity.y = 0
		await get_tree().create_timer(0.3).timeout
		dash = false
		body.velocity.x = 0

func choose_right_speed(isRunning:bool):
	if PlayerDataSaver.PlayerStats.is_dead:
		return 0
	elif isRunning:
		return runningSpeed
	else:
		return speed
