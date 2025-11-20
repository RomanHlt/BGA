extends CharacterBody2D

@export var power : float = 500
@export var power_aspiration : float = 50
@export var angle : float = 45 # En degré

@onready var centre : Vector2 = self.global_position
@onready var dir : Vector2 = Vector2(power, 0).rotated(-angle/180 * PI)
@onready var g_temp : float
@onready var target : CharacterBody2D
@onready var aspi = false
@onready var cooldown = false

func _process(delta: float) -> void:
	if target and not cooldown:
		look_at(target.global_position)
		if aspi:
			target.velocity = Vector2(-power_aspiration, 0).rotated(rotation)


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not cooldown:
		body.canMove = false
		g_temp = body.gravity_component.gravity
		body.gravity_component.gravity = 0
		aspi = true


func _on_centre_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		aspi = false
		cooldown = true
		body.hide()
		body.global_position = centre
		body.velocity = Vector2.ZERO
		look_at(dir)
		await get_tree().create_timer(2).timeout
		body.velocity = dir
		body.show()
		body.gravity_component.gravity = g_temp
		body.canMove = true
		target = null
		cooldown = false


func _on_target_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		target = body
