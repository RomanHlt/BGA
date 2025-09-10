extends Node2D

@export_subgroup("Identity")
@export var id : String
@export var spawnLayer:int = 0
@export var isHome:bool = false
var Layers:Array
var player:CharacterBody2D
var currentPlayerLayer:int = spawnLayer
var pathObstured:bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = $Player
	player.z_index = -spawnLayer
	player.collision_mask = 2**spawnLayer
	player.collision_layer = 2**spawnLayer
	Layers = get_children().filter(func (x): if x.is_class("TileMapLayer"): return x)
	player.reparent(Layers[spawnLayer])
	if !isHome:
		player.data.current_lvl = id
		Main.get_node("CanvasLayer/Menus/MenuPause").canOpen = true

	else:
		Main.get_node("CanvasLayer/Menus/MenuAccueil").show()
		Main.get_node("CanvasLayer/Menus/MenuPause").canOpen = false
		Main.get_node("CanvasLayer/Clock").stop()
	findRightSpawn()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player.canGoDeeper and Input.is_action_just_pressed("deeperLayer") and currentPlayerLayer < len(Layers)-1:
		goToLayer(currentPlayerLayer+1)
	elif player.canGoCloser and Input.is_action_just_pressed("closerLayer") and currentPlayerLayer > 0:
		goToLayer(currentPlayerLayer-1)
		
	if Input.is_action_just_pressed("stats"):
		print(player.deeperChecker.get_overlapping_areas())

func findRightSpawn():
	var rightDoor:Door
	for l in Layers:
		for d in l.get_children().filter(func (x):if x.get_script() == preload("res://PART - BASE/SCRIPTS/door.gd"):return x):
			if d.id_last_lvl == PlayerDataSaver.PlayerStats.last_lvl:
				rightDoor = d
	if rightDoor != null:
		player.position = rightDoor.position
		$Camera2D.position = rightDoor.position
		goToLayer(rightDoor.layer)
		rightDoor.isOut = true

func goToLayer(layer:int = 0):
	if player.canMove:
		if PlayerDataSaver.PlayerStats.is_dead:
			player.collision_layer = 2**layer
		
		elif player.canGoDeeper == true and currentPlayerLayer < layer:
			player.layerJump = true
			player.reparent(Layers[layer])
			$AudioStreamPlayer.play()
			player.collision_mask = 2**layer
			player.collision_layer = 2**layer
			player.z_index = -layer 
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
		elif player.canGoCloser == true and currentPlayerLayer > layer:
			player.layerJump = true
			player.reparent(Layers[layer])
			$AudioStreamPlayer.play()
			player.collision_mask = 2**layer
			player.collision_layer = 2**layer
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			player.z_index = -layer
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
