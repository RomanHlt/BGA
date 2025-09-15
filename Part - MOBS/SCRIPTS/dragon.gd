extends CharacterBody2D

var flame = preload("res://PART - MOBS/SCENES/dragon_flame.tscn")

@export var sprite:Sprite2D #??
@export var layer : int = 0

@onready var is_sleeping = true
@onready var target : CharacterBody2D = self
@onready var lock = false
@onready var on_spike = false
@onready var health = 10
@onready var is_attacked = false
@onready var is_stun = false

func _ready() -> void:
	collision_layer = 2**layer
	collision_mask = 2**layer
	get_tree().root.get_node("/root/Map/CanvasLayer/InGame/lifeController").play(str(health))
	await get_tree().create_timer(1).timeout

func _takeDamages(damages):
	is_attacked = true
	if damages <= health:
		health -= damages
		get_tree().root.get_node("/root/Map/CanvasLayer/InGame/lifeController").play(str(health))
		print(health)
	else:
		health = 0
		get_tree().root.get_node("/root/Map/CanvasLayer/InGame/lifeController").play(str(health))


func _process(delta: float) -> void:
	$GravityComponent.handle_gravity($".", delta) # Applique la gravité
	if health == 0:
		velocity[0] = 0
		$DragonAnimator.play("explosion")
		
	else:
		if velocity[1] < 0:
			$DragonAnimator.play("jump_left")
		elif velocity[1] > 0:
			$DragonAnimator.play("fall_left")
		
		if is_attacked:
			velocity[0] = 0
			$DragonAnimator.play("ouch")
		elif is_sleeping: 
			$DragonAnimator.play("Idle_left")
			velocity[0] = 0 # Arreter son déplacement
		elif lock and not is_stun:
			velocity[0] = 0 # Arreter son déplacement
			$DragonAnimator.stop()
		elif not is_stun:
			var direction = sign(target.position[0] - self.position[0]) # direction = 1 ou -1 en fonction de la position du joueur par rapport au mob
			velocity[0] = direction * 100 # Vitesse 100
			$DragonAnimator.play("walk_left")
			
		if velocity.length() > 0 and not is_sleeping: # Si le mob est en mouvement
			$Dragon.flip_h = velocity[0] > 0 #S'il bouge vers la droite on le fait tourner vers la droite sinon on le laisse à gauche
		

	move_and_slide()

func fire_left():
	var fire = flame.instantiate()
	await get_tree().create_timer(0.5).timeout
	if lock:
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
	await get_tree().create_timer(0.5).timeout
	if lock:
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
		await get_tree().create_timer(1).timeout
		$DragonAnimator.play("Spikes")

func _on_detectionup_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		lock = false

func _on_spike_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		on_spike = true
		await get_tree().create_timer(1).timeout
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


func _on_dragon_animator_animation_finished(anim_name: StringName) -> void:
	if anim_name == "explosion":
		hide()	
		queue_free()
	if anim_name == "ouch":
		is_attacked = false


func _on_below_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		is_stun = true
		self.velocity.y = -500
		if randi() % 2 == 1:
			self.velocity.x = 600
		else:
			self.velocity.x = -600
		await get_tree().create_timer(1).timeout
		is_stun = false
