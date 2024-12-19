extends Camera2D

var PLAYER:CharacterBody2D
var PLAYER_POSITION = 0
var SLOW_DOWN_RADIUS = 1000.0
const MAX_SPEED = 2000.0

var _velocity = Vector2.ZERO
var _anchor_position = Vector2.ZERO

func _ready() -> void:
	PLAYER = get_node("/root/Node2D/Player")
	PLAYER_POSITION = PLAYER.position

func _physics_process(delta):
	PLAYER_POSITION = PLAYER.position + PLAYER.get_parent().position + Vector2 (-80, 100)


	# Update camera position based on player position
	var distance_to_player = position.distance_to(PLAYER_POSITION)
	var desired_velocity = (PLAYER_POSITION - position).normalized() * MAX_SPEED
	if distance_to_player < SLOW_DOWN_RADIUS:
		desired_velocity *= (distance_to_player / SLOW_DOWN_RADIUS)
	_velocity += (desired_velocity - _velocity) / 2.0
	position += _velocity * delta
