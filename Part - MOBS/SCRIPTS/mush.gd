extends RigidBody2D

@export var damages:int = 1
var isAttacking:bool = false
var isPlayerNear:bool = false
var Player:CharacterBody2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	$AnimationPlayer.speed_scale = 1.2
	$AnimationPlayer.play("IDLE")
	$AnimationPlayer.get_animation("HIDE").loop_mode = Animation.LOOP_NONE
	$AnimationPlayer.get_animation("SHOW").loop_mode = Animation.LOOP_NONE
	
	$SmokePlayer.get_animation("SPLASH").loop_mode = Animation.LOOP_NONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isAttacking and isPlayerNear:
		Player._takeDamages(damages)
		isAttacking = false

func attack():
	$SmokePlayer.play("SPLASH")
	await get_tree().create_timer(0.3).timeout
	isAttacking = true
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Sprite2D.flip_h = ((body.position.x - position.x) <0)
		$AnimationPlayer.play("HIDE")

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		$AnimationPlayer.play("SHOW")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "HIDE":
		attack()
		$AnimationPlayer.play("HIDDEN")
	elif anim_name == "SHOW":
		$AnimationPlayer.play("IDLE")

func _on_smoke_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "SPLASH":
		$SmokePlayer.play("IDLE")
		isAttacking = false


func _on_damages_zone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if Player == null:
			Player = body
		isPlayerNear = true

func _on_damages_zone_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		isPlayerNear = false
