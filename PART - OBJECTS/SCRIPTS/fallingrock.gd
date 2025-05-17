extends Node2D

@export_category("Self settings")
@export var layer : int
@onready var inrock = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Fondu/AnimatableBody2D.collision_layer = 2**layer
	$Fondu/AnimatableBody2D.collision_mask = 2**layer
	$Fondu/AnimatableBody2D/above.collision_layer = 2**layer
	$Fondu/AnimatableBody2D/above.collision_mask = 2**layer


func _on_above_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		$Fondu/AnimationPlayer.play("Break broke broken")
		await get_tree().create_timer(0.6).timeout
		$Fondu/AnimatableBody2D.collision_layer = 0


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Break broke broken":
		visible = false
		$Fondu/AnimationPlayer.seek(0, true)
		await get_tree().create_timer(5).timeout	# Temps avant de remettre le rocher
		while inrock:
			await get_tree().create_timer(1).timeout
			print("await")
		print("Top")
		$Fondu/AnimatableBody2D.collision_layer = 2**layer
		$Fondu/FonduPlayer.play("fondu")
		await get_tree().create_timer(0.3)
		visible = true

"""
Eviter de pouvoir le casser dès qu'il apparait


"""

func _on_inrock_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		inrock = true
		print("inrock")


func _on_inrock_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		inrock = false
		print("Not inrock")
	
