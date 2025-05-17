extends Node2D

@export_category("Self Settings")
@export var layer : int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CharacterBody2D.collision_layer = 2**layer
	$CharacterBody2D.collision_mask = 2**layer
	$CharacterBody2D/under.collision_layer = 2**layer
	$CharacterBody2D/under.collision_mask = 2**layer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_under_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$CharacterBody2D.collision_layer = 0


func _on_under_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$CharacterBody2D.collision_layer = 2**layer
