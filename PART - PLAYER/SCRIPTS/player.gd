extends CharacterBody2D
class_name Player
signal pathObstrued

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component:MovementComponent
@export var advanced_jump_component: AdvancedJumpComponent
@export var animation_component: AnimationComponent
@export var weapon_component: WeaponComponent
@export_subgroup("External Nodes")
@export var camera:Camera2D
@export var enableLight:bool = true
@export_subgroup("Data")
@export var data: PlayerData = PlayerData.new()

var deeperChecker
var closerChecker
var dealingDamages
var closerRight
var closerLeft
var was_on_floor:bool = false
var canGoDeeper:bool = true
var canGoCloser:bool = true
var behindLeft:bool = false
var behindRight:bool = false
var layerJump:bool = false
var fire:bool = false
var isRunning:bool = false
var stuned = false
var direction = 0
var virtualJumpPressed:bool = false
var virtualJumpReleased:bool = false
var wantToGoDeeper:bool = false
var wantToGoCloser:bool = false
var dashing = false
@export var canMove:bool = true


func _ready():
	show()
	#Fog du monde 1 :
	var current_lvl = get_parent().id #map.id
	print("lvl :",current_lvl)
	if (current_lvl[0] == "1" or current_lvl == "0.1.0") and not current_lvl == "1.4.0": # 0.1.0 = easteregg chat, 1.4.0 = boss cvl
		$Fog.show()
	else:
		$Fog.hide()
	#setup playerdata
	data = PlayerDataSaver.PlayerStats
	print(data.health)
	#setup the layer checkers
	deeperChecker = $deeperChecker
	closerChecker = $closerChecker
	dealingDamages = $PlayerDealingDamageZone
	closerLeft = $CloserLeft
	closerRight = $CloserRight
	
	$Sprite2D/PointLight2D.enabled = enableLight
	$Sprite2D/PointLight2D2.enabled = enableLight
	$Sprite2D/PointLight2D3.enabled = enableLight

func _process(delta: float) -> void:
	var mat = get_parent().material
	if mat and mat is ShaderMaterial:
		mat.set_shader_parameter("player_pos", global_position)
		
	if stuned:
		return
	if input_component.get_fire():
		fire = true
	if input_component.get_run() and PlayerDataSaver.SettingsStats.runAsToggle:
		isRunning = !isRunning


func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	if ! Main.get_node("CanvasLayer/Menus/MenuAccueil").virtualController:
		direction = input_component.input_horizontal
	if canMove:
		movement_component.handle_dash(self,$Sprite2D.flip_h,input_component.get_dash())
		advanced_jump_component.handle_jump(self, input_component.get_jump_input() or virtualJumpPressed,virtualJumpReleased or input_component.get_jump_input_released())
		virtualJumpReleased = false
		virtualJumpPressed = false
	if PlayerDataSaver.SettingsStats.runAsToggle:
		movement_component.handle_horizontal_movement(self,direction, isRunning,canMove)
	else:
		movement_component.handle_horizontal_movement(self, direction, input_component.get_run(),canMove)

		#weapon_component._handle_fire(self, input_component.get_fire())
	animation_component.handle_move_animation(self, direction)
	move_and_slide()
	check_ground_state()


func _takeDamages(damages:int):
	if not PlayerDataSaver.PlayerStats.is_dead:
		if damages > PlayerDataSaver.PlayerStats.health:
			damages = PlayerDataSaver.PlayerStats.health
		PlayerDataSaver.PlayerStats.health -= damages
		camera.shake()
		$Blood.emitting = true
		if PlayerDataSaver.PlayerStats.health == 0:
			_dead()


func stun(time):
	"""Appeler depuis le joueur pour stun le boss"""
	stuned = true
	canMove = false
	animation_component.get_stuned()
	# Animation de stun ?
	await get_tree().create_timer(time).timeout
	animation_component.end_stun()
	stuned = false


func _heal(heals:int):
	if heals > 4 - PlayerDataSaver.PlayerStats.health: # 4 - la vie qu'on a déjà = ce qu'il nous manque
		heals = 4 - PlayerDataSaver.PlayerStats.health
	PlayerDataSaver.PlayerStats.health += heals


func _dead():
	PlayerDataSaver.PlayerStats.is_dead = true
	collision_layer = 0
	$AudioStreamPlayer.play()
	await get_tree().create_timer(1.5).timeout
	Main.get_node("CanvasLayer/Dead").dead()
	await get_tree().create_timer(1.5).timeout
	_respawn()


func _respawn():
	"""Est automatiquement appellée après la mort du joueur"""
	if get_tree().current_scene.isBoss:
		Main.get_node("Globals Levels").change_lvl(PlayerDataSaver.PlayerStats.current_lvl,"",str(PlayerDataSaver.PlayerStats.current_lvl))
	else:
		get_tree().current_scene.findRightSpawn()
	PlayerDataSaver.PlayerStats.health = PlayerDataSaver.PlayerStats.max_health
	camera.exitBossMode()
	await get_tree().create_timer(1).timeout
	show()
	PlayerDataSaver.PlayerStats.is_dead = false

# Layer Checkers
func _on_area_2d_body_entered(body: Node2D) -> void:
	canGoDeeper = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	canGoDeeper = true
func _on_closer_checker_body_entered(body: Node2D) -> void:
	canGoCloser = false
func _on_closer_checker_body_exited(body: Node2D) -> void:
	canGoCloser = true

func _on_closer_left_body_entered(body: Node2D) -> void:
	behindLeft = true
func _on_closer_left_body_exited(body: Node2D) -> void:
	behindLeft = false
func _on_closer_right_body_entered(body: Node2D) -> void:
	behindRight = true
func _on_closer_right_body_exited(body: Node2D) -> void:
	behindRight = false


func _on_animation_component_awaken() -> void:
	canMove = true #Attendre que l'animation soit finie avant de bouger




func _on_destroy_body_entered(body: Node2D) -> void:
	if body is TileMapLayer and dashing:
		var pos_in_tilemap: Vector2 = body.to_local(global_position)  # position locale du joueur dans le TileMap
		var cell: Vector2i = body.local_to_map(pos_in_tilemap)
		print(cell)
		destroy_area(body,cell,1)


func destroy_area(body, center: Vector2i, radius: int = 1) -> void:
	for x in range(-radius, radius + 1):
		for y in range(-radius, radius + 1):
			var cell = center + Vector2i(x, y)
			body.set_cell(cell, -1, Vector2i(-1, -1), 0)

# Squish and stretch
func check_ground_state(): 
	# On vient d'atterrir
	if is_on_floor() and not was_on_floor:
		_on_land()
	# On vient de décoller
	if not is_on_floor() and was_on_floor:
		_on_air()
	was_on_floor = is_on_floor()

func _on_land():
	# squish
	$Sprite2D.scale = Vector2(1.3, 0.7)
	var t = create_tween() # tween permet de faire varier un element d'un etat A à B en un temps t. Ici on fait varier la scale du sprite2D de (1.3, 0.7) à (1,1) en 0.2 s
	t.tween_property($Sprite2D, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_ELASTIC)

func _on_air():
	# stretch
	$Sprite2D.scale = Vector2(0.7, 1.3)
	var t = create_tween()
	t.tween_property($Sprite2D, "scale", Vector2.ONE, 0.2).set_trans(Tween.TRANS_ELASTIC)
