extends CharacterBody2D
signal pathObstrued
const SPEED = 150
const ACCELERATION = 1200
const FRICTION = 64000

const GRAVITY = 1000
const FALL_GRAVITY = 1500
const FAST_FALL_GARVITY = 2500
const WALL_GRAVITY = 12

const JUMP_VELOCITY = -400
const WALL_JUMP_VELOCITY = -400
const WALL_JUMP_PUSHBACK = 300
const MAX_WALL_JUMP = 2
var WALL_JUMP_STREAK = 0

const INPUT_BUFFER_PATIENCE = 0.1
const COYOTE_TIME = 0.08

var input_buffer : Timer
var coyote_timer : Timer
var coyote_jump_available : bool = true


var deeperChecker
var closerChecker
var canGoDeeper:bool = true
var canGoCloser:bool = true


func _ready():
	#setup the layer checkers
	deeperChecker = $deeperChecker
	closerChecker = $closerChecker
	#setup input buffer timer
	input_buffer = Timer.new()
	input_buffer.wait_time = INPUT_BUFFER_PATIENCE
	input_buffer.one_shot = true
	add_child(input_buffer)
	
	#setupe coyote timer
	coyote_timer = Timer.new()
	coyote_timer.wait_time = COYOTE_TIME
	coyote_timer.one_shot = true
	add_child(coyote_timer)
	coyote_timer.timeout.connect(coyote_timeout)
	

func _process(delta: float) -> void:
	if velocity.y == 0:
		if velocity.x > 0:
			lookAtLeft(false)
			$AnimationPlayer.play("RUN")
			
		elif velocity.x < 0:
			lookAtLeft(true)
			$AnimationPlayer.play("RUN")
		else:
			$AnimationPlayer.play("IDLE")
	elif velocity.y < 0:
		$AnimationPlayer.play("JUMP")
	else:
		$AnimationPlayer.play("FALL")

func _physics_process(delta: float) -> void:
	var horizontal_input = Input.get_axis("move_left","move_right")
	var jump_attempted = Input.is_action_just_pressed("jump")
	#handle jumping
	if Input.is_action_pressed("tp"):
		position.y -= 1000
	if jump_attempted or input_buffer.time_left > 0:
		if coyote_jump_available:
			velocity.y = JUMP_VELOCITY
			coyote_jump_available = false
		elif is_on_wall() and horizontal_input !=0 and WALL_JUMP_STREAK<MAX_WALL_JUMP:
			velocity.y = WALL_JUMP_VELOCITY
			velocity.x = WALL_JUMP_PUSHBACK*-sign(horizontal_input)
			WALL_JUMP_STREAK +=1
		elif jump_attempted:
			input_buffer.start()
			
	if Input.is_action_just_released("jump") and velocity.y <0:
		velocity.y = JUMP_VELOCITY /4
		
	if is_on_floor():
		coyote_jump_available = true
		coyote_timer.stop()
		WALL_JUMP_STREAK = 0
	else:
		if coyote_jump_available:
			if coyote_timer.is_stopped():
				coyote_timer.start()
		velocity.y +=get_Gravity(horizontal_input)*delta
	var floor_damping: float = 1.0 if is_on_floor() else 0.2
	var dash_multiplier:float = 2.0 if Input.is_action_pressed("dash") else 1.0
	if horizontal_input:
		velocity.x = move_toward(velocity.x,horizontal_input*SPEED*dash_multiplier,ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x,0, (FRICTION * delta)*floor_damping)
	move_and_slide()
		
func get_Gravity(input_dir:float = 0)->float:
	if Input.is_action_pressed("fast_fall"):
		return FAST_FALL_GARVITY
	if is_on_wall_only() and velocity.y > 0 and input_dir != 0:
		return WALL_GRAVITY
	return GRAVITY if velocity.y < 0 else FALL_GRAVITY


func coyote_timeout():
	coyote_jump_available = false
	
func lookAtLeft(dir:bool):
	if dir:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 4
	else:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = 0




func _on_area_2d_body_entered(body: Node2D) -> void:
	canGoDeeper = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	canGoDeeper = true


func _on_closer_checker_body_entered(body: Node2D) -> void:
	canGoCloser = false
func _on_closer_checker_body_exited(body: Node2D) -> void:
	canGoCloser = true
