extends StaticBody2D

@export_category("Nodes")
@export var layer:int
@export var gravityComponent : GravityComponent
var map

func _ready() -> void:
	map = self.owner
	#z_index = -layer
	collision_mask = 2**layer
	collision_layer = 2**layer
