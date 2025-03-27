extends Node2D

@export_subgroup("Identity")
@export var id : String
@export var spawnLayer:int = 0
var Layers:Array
var player:CharacterBody2D
var currentPlayerLayer:int = spawnLayer

var pathObstured:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	player.z_index = -spawnLayer+1
	player.collision_mask = 2**spawnLayer
	player.collision_layer = 2**spawnLayer
	Layers = get_children().filter(func (x): if x.is_class("TileMapLayer"): return x)
	player.reparent(Layers[spawnLayer])
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("deeperLayer") and currentPlayerLayer < len(Layers)-1:
		goToLayer(currentPlayerLayer+1)
	elif Input.is_action_just_pressed("closerLayer") and currentPlayerLayer > 0:
		goToLayer(currentPlayerLayer-1)
		
	if Input.is_action_just_pressed("stats"):
		print("Parent: ",player.get_parent()," | Coord: ",player.position)
		print("Z_Index: ",player.z_index, " | Collisions: ", player.collision_mask)

func goToLayer(layer:int = 0):
	if player.canGoDeeper == true and currentPlayerLayer < layer:
		player.layerJump = true
		player.reparent(Layers[layer])
		player.collision_mask = 2**layer
		player.collision_layer = 2**layer
		player.z_index = -layer +1
		player.deeperChecker.collision_mask = 2**(layer+1)
		player.closerChecker.collision_mask = 2**(layer-1)
		currentPlayerLayer=layer
	if player.canGoCloser == true and currentPlayerLayer > layer:
		player.layerJump = true
		player.reparent(Layers[layer])
		player.collision_mask = 2**layer
		player.collision_layer = 2**layer
		player.deeperChecker.collision_mask = 2**(layer+1)
		player.closerChecker.collision_mask = 2**(layer-1)
		player.z_index = -layer +1
		currentPlayerLayer=layer
