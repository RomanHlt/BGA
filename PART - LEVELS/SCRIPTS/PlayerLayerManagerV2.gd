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
	Main.get_node("Globals Options").player = player
	player.z_index = -spawnLayer
	player.collision_mask = 2**spawnLayer
	player.collision_layer = 2**spawnLayer
	player.get_node("Sprite2D").light_mask = 2**spawnLayer
	
	"""
	player.get_node("Sprite2D").get_node("PointLight2D").range_item_cull_mask = 2**spawnLayer
	if spawnLayer > 0:
		player.get_node("Sprite2D").get_node("PointLight2D0").range_item_cull_mask = 2**(spawnLayer-1)
	player.get_node("Sprite2D").get_node("PointLight2D").shadow_item_cull_mask = 2**spawnLayer
	player.get_node("Sprite2D").get_node("PointLight2D2").range_item_cull_mask = 2**(spawnLayer+1)
	player.get_node("Sprite2D").get_node("PointLight2D3").range_item_cull_mask = 2**(spawnLayer+2)
	"""
	player.get_node("Sprite2D").get_node("PointLight2D").range_item_cull_mask = 1
	player.get_node("Sprite2D").get_node("PointLight2D").shadow_item_cull_mask = 0
	if spawnLayer > 0:
		player.get_node("Sprite2D").get_node("PointLight2D0").range_item_cull_mask = 0
	player.get_node("Sprite2D").get_node("PointLight2D2").range_item_cull_mask = 2
	player.get_node("Sprite2D").get_node("PointLight2D2").shadow_item_cull_mask = 0
	player.get_node("Sprite2D").get_node("PointLight2D3").range_item_cull_mask = 4
	player.get_node("Sprite2D").get_node("PointLight2D3").shadow_item_cull_mask = 0
	
	if spawnLayer == 0:
		player.get_node("Sprite2D").get_node("PointLight2D").energy = 10
		player.get_node("Sprite2D").get_node("PointLight2D2").energy = 5
		player.get_node("Sprite2D").get_node("PointLight2D3").energy = 2
	elif spawnLayer == 1:
		player.get_node("Sprite2D").get_node("PointLight2D").energy = 9
		player.get_node("Sprite2D").get_node("PointLight2D2").energy = 10
		player.get_node("Sprite2D").get_node("PointLight2D3").energy = 5
	if spawnLayer == 2:
		player.get_node("Sprite2D").get_node("PointLight2D").energy = 8
		player.get_node("Sprite2D").get_node("PointLight2D2").energy = 9
		player.get_node("Sprite2D").get_node("PointLight2D3").energy = 10
	print(spawnLayer)
	print(player.get_node("Sprite2D").get_node("PointLight2D").energy)
			
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
		
	if player.behindLeft and player.behindRight and not player.canGoCloser:
		player.z_index = 0
	else:
		player.z_index = -currentPlayerLayer
		

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
		
		if player.canGoDeeper == true and currentPlayerLayer < layer:
			player.layerJump = true
			player.reparent(Layers[layer])
			$AudioStreamPlayer.play()
			if not Main.get_node("Globals Options").godmod_active:
				player.collision_mask = 2**layer
				player.collision_layer = 2**layer
			player.z_index = -layer 
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			player.closerRight.collision_mask = 2**(layer-1)
			player.closerLeft.collision_mask = 2**(layer-1)
			player.get_node("Sprite2D").light_mask = 2**layer
			"""
			player.get_node("Sprite2D").get_node("PointLight2D").range_item_cull_mask = 2**layer
			if layer > 0:
				player.get_node("Sprite2D").get_node("PointLight2D0").range_item_cull_mask = 2**(layer-1)
			player.get_node("Sprite2D").get_node("PointLight2D").shadow_item_cull_mask = 2**layer
			player.get_node("Sprite2D").get_node("PointLight2D2").range_item_cull_mask = 2**(layer+1)
			player.get_node("Sprite2D").get_node("PointLight2D3").range_item_cull_mask = 2**(layer+2)
			"""
			
			if layer == 0:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 10
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 5
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 2
			elif layer == 1:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 9
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 10
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 5
			elif layer == 2:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 8
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 9
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 10
			print(layer)
			print(player.get_node("Sprite2D").get_node("PointLight2D").energy)
			
			
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
		elif player.canGoCloser == true and currentPlayerLayer > layer:
			player.layerJump = true
			player.reparent(Layers[layer])
			$AudioStreamPlayer.play()
			if not Main.get_node("Globals Options").godmod_active:
				player.collision_mask = 2**layer
				player.collision_layer = 2**layer
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			player.closerRight.collision_mask = 2**(layer-1)
			player.closerLeft.collision_mask = 2**(layer-1)
			player.get_node("Sprite2D").light_mask = 2**layer
			"""
			player.get_node("Sprite2D").get_node("PointLight2D").range_item_cull_mask = 2**layer
			if layer > 0:
				player.get_node("Sprite2D").get_node("PointLight2D0").range_item_cull_mask = 2**(layer-1)
			player.get_node("Sprite2D").get_node("PointLight2D").shadow_item_cull_mask = 2**layer
			player.get_node("Sprite2D").get_node("PointLight2D2").range_item_cull_mask = 2**(layer+1)
			player.get_node("Sprite2D").get_node("PointLight2D3").range_item_cull_mask = 2**(layer+2)
			"""
			
			# Intensité
			if layer == 0:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 10
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 5
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 2
			elif layer == 1:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 9
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 10
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 5
			elif layer == 2:
				player.get_node("Sprite2D").get_node("PointLight2D").energy = 8
				player.get_node("Sprite2D").get_node("PointLight2D2").energy = 9
				player.get_node("Sprite2D").get_node("PointLight2D3").energy = 10
			print(layer)
			print(player.get_node("Sprite2D").get_node("PointLight2D").energy)
			
			
			player.z_index = -layer
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
	
