extends Area2D
class_name Checkpoint

@export var layer:int
@export var order:int = 0
var isActivated:bool = false
var player:Player
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision_layer = 0
	collision_mask = 2**layer
	z_index = get_parent().z_index +1

func _on_body_entered(body: Node2D) -> void:
	if body is Player and isActivated == false:
		print("hey")
		player = body
		isActivated = true
		$AnimationPlayer.play("On")
		PlayerDataSaver._handle_save()
