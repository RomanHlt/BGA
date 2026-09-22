extends Node2D

@export var speed : float = 1
@export var wavespeed : float = 1 # Temps entre deux phases (montée/descente)
@export var amplitude : float = 10

@export_category("Steps")
@export var s0 : Vector2
@export var s1 : Vector2
@export var s2 : Vector2
@export var s3 : Vector2
@export var s4 : Vector2
"""
Grosse flemme ça va être long pour rien donc voici un systeme de singe qui fonctionne. Je le ferais en mieux un jour si on l'utilise beaucoup :
Vector2(0, 0) -> Idle
Vector2(x, y) -> Aller à ce point
"""

var timer = 0
var moving := false
var idle := true
var target : Vector2
var s : Array[Vector2]

func _ready() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	global_position = s0
	s = [s0, s1, s2, s3, s4]

func _process(delta: float) -> void:
	# Waves
	timer += delta
	$Sprite2D.position.y = sin(timer * wavespeed) * amplitude

func _physics_process(_delta: float) -> void:
	if moving:
		move_to(target)

func move_to(target_position) -> void:
	var distance := global_position.distance_to(target_position)
	if distance <= 5:
		moving = false
		idle = true
	var direction := global_position.direction_to(target_position)
	global_position += direction * speed

func step(n):
	if s[n] == Vector2(0, 0):
		idle = true
		moving = false
	else:
		target = s[n]
		moving = true
		idle = false

func boom():
	"""C'est dans le nom."""
	$Sprite2D/Left_particles.amount = 100000000
	$Sprite2D/Left_particle.amount = 100000000
	await get_tree().create_timer(1).timeout
	$Sprite2D/Right_particles.amount = 100
	$Sprite2D/Right_particles.amount = 100

func start_roberto():
	show()
	set_process(true)
	set_physics_process(true)
	step(0)
	

func end_roberto():
	"""Freez roberto en attendant le prochain dialogue"""
	step(0)
	await get_tree().create_timer(3).timeout
	hide()
	set_process(false)
	set_physics_process(false)
