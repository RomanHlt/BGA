class_name AdvancedJumpComponent
extends Node2D

@export_subgroup("Nodes")
@export var jump_buffer_timer: Timer
@export var coyote_timer: Timer
@export var wall_jump_buffer : Timer
@export var music:AudioStreamPlayer
@export_subgroup("Player's Nodes")
@export var sprite2D: Sprite2D

@export_subgroup("Settings")
@export var jump_velocity: float = -350
@export var wall_jump_backward: float=100
@export var wall_jump_max: int
var wall_jump_streak:int = 0

var is_going_up: bool = false
var is_jumping:bool=false
var last_frame_on_floor:bool=false

func has_just_landed(body:CharacterBody2D) ->bool:
	return body.is_on_floor() and not last_frame_on_floor and is_jumping

func is_allowed_to_jump(body:CharacterBody2D, want_to_jump:bool) ->bool:
	return want_to_jump and (body.is_on_floor() or not coyote_timer.is_stopped() or body.is_on_wall() or not wall_jump_buffer.is_stopped())

func handle_jump(body: CharacterBody2D, want_to_jump: bool, jump_released: bool) -> void:
	if has_just_landed(body):
		is_jumping = false
		wall_jump_streak=0
	if is_allowed_to_jump(body, want_to_jump):
		jump(body)
	
	handle_coyote_time(body)
	handle_jump_buffer(body, want_to_jump)
	handle_variable_jump_height(body, jump_released)
	handle_wall_jump_buffer(body)
	
	is_going_up = body.velocity.y < 0 and not body.is_on_floor()
	last_frame_on_floor = body.is_on_floor()
	
func handle_coyote_time(body:CharacterBody2D)->void:
	if not body.is_on_floor() and last_frame_on_floor and not is_jumping:
		coyote_timer.start()
		
	if not coyote_timer.is_stopped() and not is_jumping:
		body.velocity.y=0

func handle_wall_jump_buffer(body:CharacterBody2D)->void:
	if not body.is_on_floor() and body.is_on_wall():
		wall_jump_buffer.start()

func handle_jump_buffer(body:CharacterBody2D, want_to_jump:bool) -> void:
	if want_to_jump and not body.is_on_floor():
		jump_buffer_timer.start()
	if body.is_on_floor() and not jump_buffer_timer.is_stopped():
		jump(body)	
func handle_variable_jump_height(body:CharacterBody2D, jump_released:bool) -> void:
	if jump_released and is_going_up:
		body.velocity.y = 0

func jump(body: CharacterBody2D) -> void:
	if wall_jump_streak<wall_jump_max+1:
		wall_jump_streak+=1
		body.velocity.y = jump_velocity
		jump_buffer_timer.stop()
		is_jumping=true
		coyote_timer.stop()
		if body.is_on_wall() and not(wall_jump_buffer.is_stopped()):
			if sprite2D.flip_h:
				body.velocity.x += wall_jump_backward
				sprite2D.flip_h = false
				sprite2D.offset.x = 0
			else:
				body.velocity.x += -wall_jump_backward
				sprite2D.flip_h = true
				sprite2D.offset.x = 4
			wall_jump_buffer.stop()
