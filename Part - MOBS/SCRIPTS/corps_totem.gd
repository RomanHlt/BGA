extends RigidBody2D

@export_category("Nodes")
@export var layer:int
var map


func _ready() -> void:
	collision_mask = 2**layer
	collision_layer = 2**layer
	map = self.owner
