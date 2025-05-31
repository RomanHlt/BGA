extends CharacterBody2D

var flame = preload("res://PART - MOBS/SCENES/dragon_flame.tscn")

@export var sprite:Sprite2D #??
@export var layer : int = 0

@onready var is_sleeping = true
@onready var target : CharacterBody2D = self
@onready var lock = false
@onready var on_spike = false

func _ready() -> void:
	collision_layer = 2**layer
	collision_mask = 2**layer
	await get_tree().create_timer(1).timeout

func _process(delta: float) -> void:
	$GravityComponent.handle_gravity($".", delta) # Applique la gravité
	
	if velocity[1] < 0:
		$DragonAnimator.play("jump_left")
	elif velocity[1] > 0:
		$DragonAnimator.play("fall_left")
	
	elif is_sleeping: 
		$DragonAnimator.play("Idle_left")
		velocity[0] = 0 # Arreter son déplacement
	elif lock:
		velocity[0] = 0 # Arreter son déplacement
	else:
		var direction = sign(target.position[0] - self.position[0]) # direction = 1 ou -1 en fonction de la position du joueur par rapport au mob
		velocity[0] = direction * 100 # Vitesse 100
		$DragonAnimator.play("walk_left")
		
	if velocity.length() > 0 and not is_sleeping: # Si le mob est en mouvement
		$Dragon.flip_h = velocity[0] > 0 #S'il bouge vers la droite on le fait tourner vers la droite sinon on le laisse à gauche
		

	move_and_slide()

func fire_left():
	var fire = flame.instantiate()
	call_deferred("add_child", fire)
	fire.collision_layer = collision_layer
	fire.collision_mask = collision_mask
	fire.z_index = z_index
	fire.position = Vector2(-25, 0)
	fire.anime("left")
	$DragonAnimator.play("Attack")
	while lock:
		await get_tree().process_frame  # attend la frame suivante tant que le dragon crache du feu
	fire.stop()


func fire_right():
	var fire2 = flame.instantiate()
	call_deferred("add_child", fire2)
	fire2.collision_layer = collision_layer
	fire2.collision_mask = collision_mask
	fire2.z_index = z_index
	fire2.position = Vector2(45, 0)
	fire2.anime("right")
	$DragonAnimator.play("Attack")
	while lock:
		await get_tree().process_frame  # attend la frame suivante tant que le dragon crache du feu
	fire2.stop()
	

# Chasse
func _on_detectionarea_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = false
		target = body

func _on_detectionarea_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		is_sleeping = true


# Attaque flame
func _on_detectionleft_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock = true
		fire_left()

func _on_detectionright_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock = true
		fire_right()

func _on_detectionleft_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		lock = false

func _on_detectionright_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		lock = false


# Attaque spike
func _on_detectionup_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		lock = true
		$DragonAnimator.play("Spikes")

func _on_detectionup_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		lock = false

func _on_spike_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_spike = true
		while on_spike:
			body._takeDamages(1)
			await get_tree().create_timer(1).timeout

func _on_spike_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		on_spike = false


# Saut
func _on_collision_left_body_entered(body: Node2D) -> void:
	if body.name != "Player" and velocity[0] < 0:  # Si on va vers la gauche et qu'on croise un obstacle (or joueur) : sauter
		$AdvancedJumpComponent.jump(self)

func _on_collision_right_body_entered(body: Node2D) -> void:
	if body.name != "Player" and velocity[0] > 0:
		$AdvancedJumpComponent.jump(self)
