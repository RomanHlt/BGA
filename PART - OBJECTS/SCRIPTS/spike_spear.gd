extends Node2D

@export_category("Self Settings")
@export var layer : int
@export var damage : float

@onready var on_area = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimatableBody2D.collision_layer = 2**layer
	$AnimatableBody2D.collision_mask = 2**layer
	$AnimatableBody2D/Dps2.collision_layer = 2**layer
	$AnimatableBody2D/Dps2.collision_mask = 2**layer
	if $AnimatableBody2D/Spear_base:
		$AnimatableBody2D/Spear_base.collision_layer = 2**layer
		$AnimatableBody2D/Spear_base.collision_mask = 2**layer
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_dps_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_area = true
		$Spikeplayer.play("Pik")
		await get_tree().create_timer(0.42).timeout
		dps(body)


func _on_dps_2_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		on_area = false


func dps(body):
	if on_area:
		body._takeDamages(damage)


func _on_spear_base_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		body._takeDamages(damage)
