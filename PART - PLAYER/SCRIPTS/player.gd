extends CharacterBody2D
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
@export_subgroup("Data")
@export var data: PlayerData = PlayerData.new()

var deeperChecker
var closerChecker
var canGoDeeper:bool = true
var canGoCloser:bool = true
var layerJump:bool = false
var fire:bool = false
var isRunning:bool = false
@export var canMove:bool = true


func _ready():
	#setup playerdata
	data = PlayerDataSaver.PlayerStats
	#setup the layer checkers
	deeperChecker = $deeperChecker
	closerChecker = $closerChecker


func _process(delta: float) -> void:
	if input_component.get_fire():
		fire = true
	if input_component.get_run() and PlayerDataSaver.SettingsStats.runAsToggle:
		isRunning = !isRunning
	
func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	if canMove:
		if PlayerDataSaver.SettingsStats.runAsToggle:
			movement_component.handle_horizontal_movement(self, input_component.input_horizontal, isRunning)
		else:
			movement_component.handle_horizontal_movement(self, input_component.input_horizontal, input_component.get_run())
		advanced_jump_component.handle_jump(self, input_component.get_jump_input(),input_component.get_jump_input_released())
		#weapon_component._handle_fire(self, input_component.get_fire())
	animation_component.handle_move_animation(self, input_component.input_horizontal)
	move_and_slide()

func _takeDamages(damages:int):
	if not PlayerDataSaver.PlayerStats.is_dead:
		if damages > PlayerDataSaver.PlayerStats.health:
			damages = PlayerDataSaver.PlayerStats.health
		PlayerDataSaver.PlayerStats.health -= damages
		camera.shake()
		if PlayerDataSaver.PlayerStats.health == 0:
			_dead()

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
	PlayerDataSaver.PlayerStats.health = PlayerDataSaver.PlayerStats.max_health
	get_tree().root.get_node("Map").findRightSpawn()
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
