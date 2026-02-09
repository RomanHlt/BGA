extends RigidBody2D

@export_category("Nodes")
@export var layer:int
@export var wind_force : Vector2
@export var look_at_right : bool = false
var blowing : bool = false
var map
var inside : bool = false
var target : CharacterBody2D


func _ready() -> void:
	collision_mask = 2**layer
	collision_layer = 2**layer
	if look_at_right:
		$Sprite2D.flip_h = true
		$WindArea.position.x += 54 
	$WindArea.collision_layer = 0
	$WindArea.collision_mask = 2**layer
	$Sprite2D/AnimationPlayer.play("Idle")
	map = self.owner

func _process(delta: float) -> void:
	if inside:
		target.velocity = wind_force

func _on_wind_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
		inside = true

func _on_wind_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inside = false



func _on_attack_timer_timeout() -> void:
	blowing = !blowing
	if blowing:
		$Sprite2D/AnimationPlayer.play("attackDebut")
		$Sprite2D/AnimationPlayer.play("attackContinue")
		set_process(true)
	else:
		set_process(false)
		$Sprite2D/AnimationPlayer.play("Idle")
