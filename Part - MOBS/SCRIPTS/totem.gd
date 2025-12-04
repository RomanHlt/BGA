extends CharacterBody2D

@export_category("Nodes")
@export var layer:int
@export var wind_force : Vector2
@export var gravity: int
var blowing : bool = false
var map


func _ready() -> void:
	collision_mask = 2**layer
	collision_layer = 2**layer
	$WindArea.collision_layer = 0
	$WindArea.collision_mask = 2**layer
	$Sprite2D/AnimationPlayer.play("Idle")
	map = self.owner
	
func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += gravity*delta
	move_and_slide()

func _on_wind_area_body_entered(body: Node2D) -> void:
	if body.name == "Player" and blowing:
		body.velocity += wind_force


func _on_attack_timer_timeout() -> void:
	blowing = !blowing
	if blowing:
		$Sprite2D/AnimationPlayer.play("attackDebut")
		$Sprite2D/AnimationPlayer.play("attackContinue")
	else:
		$Sprite2D/AnimationPlayer.play("Idle")
