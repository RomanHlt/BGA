extends CharacterBody2D

@export var power : float = 1000
@export var power_aspiration : float = 50
@export var marker:Marker2D
@export var layer_dir : int = 0

@onready var centre : Vector2 = self.global_position
@onready var dir : Vector2 = Vector2(power, 0).rotated(find_angle())
@onready var g_temp : float
@onready var target : CharacterBody2D
@onready var aspi = false
@onready var cooldown = false

func _ready() -> void:
	if not marker:
		print("PAS DE MARKER POUR LE NUAGE :", self)
	$AnimationPlayer.play("Idle")

func _process(delta: float) -> void:
	if target and not cooldown:
		look_at(target.global_position + Vector2(0, -10))
		if aspi:
			target.velocity = Vector2(-power_aspiration, 0).rotated(rotation)


func find_angle() -> float:
	var direction = marker.global_position - global_position
	return direction.angle()



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not cooldown:
		body.canMove = false
		g_temp = body.gravity_component.gravity
		body.gravity_component.gravity = 0
		aspi = true
		$AnimationPlayer.play("Inspiration")


func _on_centre_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		aspi = false
		$Area2D.monitoring = false
		$target.monitoring = false
		$AnimationPlayer.play("wait")
		cooldown = true
		body.hide()
		body.global_position = centre
		body.velocity = Vector2.ZERO
		body.canMove = true
		get_parent().get_parent().goToLayer(layer_dir)
		body.canMove = false
		self.rotation = find_angle()
		await get_tree().create_timer(2).timeout
		$AnimationPlayer.play("Souffle")
		await get_tree().create_timer(0.2).timeout
		body.velocity = dir
		body.show()
		body.gravity_component.gravity = g_temp
		body.canMove = true
		target = null
		cooldown = false
		await get_tree().create_timer(1.5).timeout
		$Area2D.monitoring = true
		$target.monitoring = true
		await  get_tree().create_timer(0.5).timeout
		$AnimationPlayer.play("Idle")
		await get_tree().create_timer(0.5).timeout
		look_at(Vector2.RIGHT)


func _on_target_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
