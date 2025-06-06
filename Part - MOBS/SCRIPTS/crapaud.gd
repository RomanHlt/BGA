extends CharacterBody2D

@export_subgroup("Nodes")
@export var speed: float
@export var gravity : GravityComponent
@export var layer: int
var dead: bool = false
var sleeping: bool
var attacking: bool = false
var see_player: bool = false
var walking: bool = false
var take_damage: bool = false
var direction: Vector2
var PV_max: int
var PV: int
var player: CharacterBody2D
var map

func _ready() -> void:
	map = self.owner
	collision_layer = 2**layer
	collision_mask = 2**layer
	

func _physics_process(delta: float) -> void:
	gravity.handle_gravity(self, delta)
	move_and_slide()

func _process(delta: float) -> void:
	_animation()
	_move(delta)

func _animation():
	pass

func _move(delta:float):
	pass
