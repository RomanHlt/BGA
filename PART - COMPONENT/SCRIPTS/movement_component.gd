class_name MovementComponent
extends Node2D

@export_subgroup("Settings")
@export var speed: float = 100
@export var runningSpeed: float = 250
@export var ground_accel_speed: float = 6.0
@export var ground_decel_speed: float = 8.0
@export var air_accel_speed: float = 10.0
@export var air_decel_speed: float = 3.0


func handle_horizontal_movement(body:CharacterBody2D, direction:float, isRunning:bool) ->void:
	var velocity_change_speed: float = 0.0
	if body.is_on_floor():
		velocity_change_speed = ground_accel_speed if direction != 0 else ground_decel_speed
	else:
		velocity_change_speed = air_accel_speed if direction != 0 else air_decel_speed
	
	body.velocity.x = move_toward(body.velocity.x, direction * choose_right_speed(isRunning), velocity_change_speed)

func choose_right_speed(isRunning:bool):
	if PlayerDataSaver.PlayerStats.is_dead:
		return 0
	elif isRunning:
		return runningSpeed
	else:
		return speed
