extends Path2D

@export var pathspeed : float = 10.0
@export var wavespeed : float = 0.75
@export var amplitude : float = 0.1

var incr = 0

func _ready() -> void:
	await get_tree().create_timer(5).timeout
	boom()

func _process(delta: float) -> void:
	$PathFollow2D.progress += delta * pathspeed
	# Waves
	incr += delta*wavespeed
	print(roundi(incr)%2==0)
	if roundi(incr) % 2 == 0: # Si incr est paire (valeur arrondie)
		$PathFollow2D/Body.position.y += amplitude
	else:
		$PathFollow2D/Body.position.y -= amplitude


func boom():
	$PathFollow2D/Body/Left_particles.amount = 10000000
	$PathFollow2D/Body/Right_particles.amount = 10000000
	await get_tree().create_timer(1).timeout
	$PathFollow2D/Body/Left_particles.amount = 100
	$PathFollow2D/Body/Right_particles.amount = 100
