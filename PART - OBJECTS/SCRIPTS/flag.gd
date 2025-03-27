extends Area2D

@export var layer:int
var isActivated:bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 0
	collision_mask = 2**layer
	z_index = get_parent().z_index +1

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and isActivated == false:
		print("hey")
		isActivated = true
		$AnimationPlayer.play("On")
		PlayerDataSaver._handle_save()
