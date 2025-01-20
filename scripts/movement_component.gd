class_name MovementComponent
extends Node2D

@export_subgroup("Settings")
@export var speed: float = 100

func handle_horizontal_movement(body:CharacterBody2D, direction:float) ->void:
	body.velocity.x = direction * speed
