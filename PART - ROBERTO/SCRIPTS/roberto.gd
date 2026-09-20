extends Path2D

@export var pathspeed : float = 50.0
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
Vector2(1, 1) -> Suivre le path de Roberto
Vector2(x, y), autre que les deux précédents -> Aller à ce point

Ex d'utilisation
Dans Dialogue :
~ Titre
do begin()
do step(0)
Blablabla
"""

@onready var body: Node2D = $PathFollow2D/Body

var timer = 0
var moving := false
var idle := true
var target : Vector2
var s : Array[Vector2]

func _ready() -> void:
	hide()
	set_process(false)
	set_physics_process(false)
	$PathFollow2D/Body.position = s0
	s = [s0, s1, s2, s3, s4]

func _process(delta: float) -> void:
	if not moving and not idle:
		$PathFollow2D.progress += delta * pathspeed
	if (moving or idle) and $PathFollow2D.progress > 5:
		$PathFollow2D.progress -= delta * 2*pathspeed
	# Waves
	timer += delta
	if not moving:
		$PathFollow2D/Body.position.y = sin(timer * wavespeed) * amplitude

func _physics_process(_delta: float) -> void:
	if moving:
		move_to(target)

func move_to(target_position) -> void:
	var distance := body.global_position.distance_to(target_position)
	if distance <= 5:
		moving = false
		idle = true
	var direction := body.global_position.direction_to(target_position)
	body.global_position += direction * 3

func step(n):
	if s[n] == Vector2(0, 0):
		idle = true
		moving = false
	elif s[n] == Vector2(1, 1):
		idle = false
		moving = false
	else:
		target = s[n]
		moving = true
		idle = false



func boom():
	"""C'est dans le nom."""
	$PathFollow2D/Body/Left_particles.amount = 100000000
	$PathFollow2D/Body/Right_particles.amount = 100000000
	await get_tree().create_timer(1).timeout
	$PathFollow2D/Body/Left_particles.amount = 100
	$PathFollow2D/Body/Right_particles.amount = 100

func start_roberto():
	show()
	set_process(true)
	set_physics_process(true)
	step(0)
	

func end_roberto():
	"""Freez roberto en attendant le prochain dialogue"""
	step(0)
	await get_tree().create_timer(5).timeout
	hide()
	set_process(false)
	set_physics_process(false)
