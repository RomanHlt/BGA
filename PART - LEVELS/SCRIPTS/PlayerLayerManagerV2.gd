extends Node2D

@export_subgroup("Identity")
@export var id : String
@export var spawnLayer:int = 0
@export var isHome:bool = false
@export var isBoss : bool = false
@export_subgroup("Player")
@export var player:CharacterBody2D
var Layers:Array
var currentPlayerLayer:int = spawnLayer
var pathObstured:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Main.get_node("Globals Options").player = player
	player.z_index = -spawnLayer
	player.collision_mask = 2**spawnLayer
	player.collision_layer = 2**spawnLayer
	player.dealingDamages.collision_mask = 2**spawnLayer
	player.get_node("Sprite2D").light_mask = 2**spawnLayer
	player.get_node("Sprite2D").get_node("PointLight2D").range_item_cull_mask = 1
	player.get_node("Sprite2D").get_node("PointLight2D").shadow_item_cull_mask = 0
	player.get_node("Sprite2D").get_node("PointLight2D2").range_item_cull_mask = 2
	player.get_node("Sprite2D").get_node("PointLight2D2").shadow_item_cull_mask = 1
	player.get_node("Sprite2D").get_node("PointLight2D3").range_item_cull_mask = 4
	player.get_node("Sprite2D").get_node("PointLight2D3").shadow_item_cull_mask = 2

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
	var check:Checkpoint
	for l in Layers:
		for d in l.get_children().filter(func (x):if x.get_script() == preload("res://PART - BASE/SCRIPTS/door.gd"):return x):
			if d.id_last_lvl == PlayerDataSaver.PlayerStats.last_lvl:
				rightDoor = d
	for l in Layers:
		for c in l.get_children().filter(func (x):if x.get_script() == preload("res://PART - OBJECTS/SCRIPTS/flag.gd"):return x):
			if c.isActivated:
				if check != null:
					if check.order < c.order:
						check = c
				else:
					check = c
	if rightDoor != null:
		if check != null:
			player.position = check.position
			$Camera2D.position = check.position
			goToLayer(check.layer)
		else:
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
			player.dealingDamages.collision_mask = 2**layer
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			player.closerRight.collision_mask = 2**(layer-1)
			player.closerLeft.collision_mask = 2**(layer-1)
			player.get_node("Sprite2D").light_mask = 2**layer
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
			
			# En mode super vitesse
			"""Main.get_child(4).get_child(0).show() # Comme on était déjà en mode brut dans ce script j'ai pas essayé de faire propre MY BAD
			player.camera.shake(5)
			player.camera.zoom.x += -0.2
			player.camera.zoom.y += -0.2
			await get_tree().create_timer(0.2).timeout
			player.camera.zoom.x += 0.2
			player.camera.zoom.y += 0.2
			Main.get_child(4).get_child(0).hide()"""
			
		elif player.canGoCloser == true and currentPlayerLayer > layer:
			player.layerJump = true
			player.reparent(Layers[layer])
			$AudioStreamPlayer.play()
			if not Main.get_node("Globals Options").godmod_active:
				player.collision_mask = 2**layer
				player.collision_layer = 2**layer
			player.dealingDamages.collision_mask = 2**layer
			player.deeperChecker.collision_mask = 2**(layer+1)
			player.closerChecker.collision_mask = 2**(layer-1)
			player.closerRight.collision_mask = 2**(layer-1)
			player.closerLeft.collision_mask = 2**(layer-1)
			player.get_node("Sprite2D").light_mask = 2**layer
			
			
			player.z_index = -layer
			currentPlayerLayer=layer
			player.position.y+=1 #Eviter que les checker ne detectent plus de collisions (patch de brute)
			
			"""Main.get_child(4).get_child(0).show()
			player.camera.shake(5)
			player.camera.zoom.x += 0.1
			player.camera.zoom.y += 0.1
			await get_tree().create_timer(0.2).timeout
			player.camera.zoom.x += -0.1
			player.camera.zoom.y += -0.1
			Main.get_child(4).get_child(0).hide()"""
