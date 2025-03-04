extends CharacterBody2D
signal pathObstrued

@export_subgroup("Nodes")
@export var gravity_component: GravityComponent
@export var input_component: InputComponent
@export var movement_component:MovementComponent
@export var advanced_jump_component: AdvancedJumpComponent
@export var animation_component: AnimationComponent

var deeperChecker
var closerChecker
var canGoDeeper:bool = true
var canGoCloser:bool = true
var layerJump:bool = false


func _ready():
	#setup the layer checkers
	deeperChecker = $deeperChecker
	closerChecker = $closerChecker


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	gravity_component.handle_gravity(self,delta)
	movement_component.handle_horizontal_movement(self, input_component.input_horizontal, input_component.get_run())
	advanced_jump_component.handle_jump(self, input_component.get_jump_input(),input_component.get_jump_input_released())
	animation_component.handle_move_animation(self, input_component.input_horizontal)
	move_and_slide()


func lookAtLeft(dir:bool):
	if dir:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 4
	else:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = 0


# Layer Checkers
func _on_area_2d_body_entered(body: Node2D) -> void:
	canGoDeeper = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	canGoDeeper = true
func _on_closer_checker_body_entered(body: Node2D) -> void:
	canGoCloser = false
func _on_closer_checker_body_exited(body: Node2D) -> void:
	canGoCloser = true
