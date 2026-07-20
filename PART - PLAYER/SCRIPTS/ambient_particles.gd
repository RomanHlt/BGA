extends CPUParticles2D

@onready var parent = get_parent()

func _ready() -> void:
	randomiser()

func _process(_delta: float) -> void:
	global_position = parent.global_position


func randomiser():
	"""
	Applique des modifications aléatoires au bout d'un certain temps.
	Les modifications sont encadré et se font petit à petit pour garder de la cohérence.
	-1 -> on baisse le parametre
	0 -> on ne touche pas au parametre
	1 -> on augmente le parametre
	"""
	var random : int
	# Temps entre deux modifications
	var time = randi_range(3, 8)
	await get_tree().create_timer(time).timeout
	
	# Initial Velocity
	const MAX_VELOCITY_MAX = 100
	const MIN_VELOCITY_MAX = 60
	const MAX_VELOCITY_MIN = 40
	const MIN_VELOCITY_MIN = 5
	random = randi_range(-1, 1)
	match random:
		-1:
			initial_velocity_min = max(MIN_VELOCITY_MIN, initial_velocity_min - 5)
		1:
			initial_velocity_min = min(MAX_VELOCITY_MIN, initial_velocity_min + 5)
	random = randi_range(-1, 1)
	match random:
		-1:
			initial_velocity_max = max(MIN_VELOCITY_MAX, initial_velocity_max - 5)
		1:
			initial_velocity_max = min(MAX_VELOCITY_MAX, initial_velocity_max + 5)
	
	# Direction
	random = randi_range(-1, 1)
	match random:
		-1:
			direction = Vector2(-1,0)
		1:
			direction = Vector2(1,0)
	
	# Gravity
	random = randi_range(-1, 1)
	match random:
		-1:
			gravity = Vector2(0, -10)
		1:
			gravity = Vector2(0, 10)
	
	#DEBUG
	print("vel_min : ", initial_velocity_min,
	"\nvel_max : ", initial_velocity_max,
	"\ndir : ", direction,
	"\ngravity : ", gravity)
	#ENDDEBUG
	randomiser()
