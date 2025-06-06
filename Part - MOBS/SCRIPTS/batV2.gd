extends CharacterBody2D

@export_subgroup("Nodes")
@export var SPEED : float
@export var gravityComponent : GravityComponent
@export var layer: int
var map
var sprite: AnimatedSprite2D
var dead: bool = false
var chase: bool =false
var attack: bool = false
var sleep: bool = true

func _choose(array):
	array.shuffle()
	return array.front()

func _ready() -> void:
	sprite.name = _choose([$Fire, $Albino, $Root, $Standart, $Vampire, $Zombie])
	for child in get_children():
		if child.is_class("AnimatedSprite2D") and child.name != sprite.name:
			child.hide()
	
	map = self.owner
	#z_index = -layer
	collision_mask = 2**layer
	collision_layer = 2**layer
