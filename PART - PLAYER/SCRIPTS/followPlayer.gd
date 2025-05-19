extends Camera2D


@export_subgroup("Settings")
@export var PLAYER:CharacterBody2D
@export var playerOffset:Vector2
@export_subgroup("Effects Settings")
@export var random_strength = 30
@export var shake_fade = 5.0
var shake_strength = 0.0

var PLAYER_POSITION = 0
var SLOW_DOWN_RADIUS = 20.0
const MAX_SPEED = 2000.0

var _velocity = Vector2.ZERO
var _anchor_position = Vector2.ZERO

func shake():
	shake_strength = random_strength
func random_offset():
	return Vector2(randf_range(-shake_strength,shake_strength),randf_range(-shake_strength,shake_strength))
func _ready() -> void:
	PLAYER_POSITION = PLAYER.position

func _physics_process(delta):
	PLAYER_POSITION = PLAYER.position + PLAYER.get_parent().position  + playerOffset


	# Update camera position based on player position
	var distance_to_player = position.distance_to(PLAYER_POSITION)
	var desired_velocity = (PLAYER_POSITION - position).normalized() * MAX_SPEED
	if distance_to_player < SLOW_DOWN_RADIUS:
		desired_velocity *= (distance_to_player / SLOW_DOWN_RADIUS)
	_velocity += (desired_velocity - _velocity) / 2.0
	position += _velocity * delta
	
	#Afficher les tremblements
	if shake_strength>0:
		shake_strength = lerpf(shake_strength,0,shake_fade*delta)
		offset = random_offset()
