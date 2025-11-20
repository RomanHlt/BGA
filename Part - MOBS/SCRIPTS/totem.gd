extends CharacterBody2D

@export_category("Nodes")
@export var layer:int
@export var wind_force : Vector2
@export var blowing_interval : int
var blowing : bool = false


func _ready() -> void:
	collision_mask = 2**layer
	collision_layer = 2**layer
	$WindArea.collision_layer = 0
	$WindArea.collision_mask = 0

func _process(delta: float) -> void:
	_start_blowing()
	_animation()

func _start_blowing():
	blowing = true
	$WindArea.collision_mask = 2**layer
	await get_tree().create_timer(0.5).timeout 
	$WindArea.collision_mask = 0
	blowing = false
	await get_tree().create_timer(blowing_interval).timeout 
	_start_blowing()

func _animation():
	if blowing:
		$Sprite2D/AnimationPlayer.play("attack")
	else:
		$Sprite2D/AnimationPlayer.play("Idle")


func _on_wind_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body.velocity = wind_force
