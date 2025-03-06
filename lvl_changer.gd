extends Area2D

@export var layer: int  # Layer de l'objet
@export var sprite: Texture2D  # Sprite de l'objet avec lequel interagir
@export var texte: String = "Appuyez sur [E] pour utiliser l'échelle"  # Texte affiché
@export var next_scene: String  # Le chemin de la scène du prochain niveau
@export var loading_scene: PackedScene  # Scène de chargement


@onready var can_interact = false  # Peut-on interagir ?
var is_loading = false  # Empêche de spammer le changement de scène

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script ne sera pas afecté par les pauses.
	$Panel/Label.text = texte
	collision_layer = 0
	collision_mask = 2**layer
	if sprite:
		$Sprite2D.texture = sprite
	else:
		print("⚠ Aucune texture assignée à l'objet !")

func _on_body_entered(body: Node2D) -> void:
	"""Affiche le texte d'interaction"""
	$Panel.visible = true
	can_interact = true

func _on_body_exited(body: Node2D) -> void:
	"""Cache le texte d'interaction"""
	$Panel.visible = false
	can_interact = false

func _input(event: InputEvent) -> void:
	"""Déclenche le changement de niveau"""
	if Input.is_action_just_pressed("interagir") and can_interact and not is_loading:
		is_loading = true
		change_level()

func change_level() -> void:
	"""Gère le changement de niveau avec une scène de chargement"""
	if not next_scene or not loading_scene:
		print("⚠ Erreur: `next_scene` ou `loading_scene` n'est pas assigné")
		return

	# Afficher la scène de chargement
	var loading_instance = loading_scene.instantiate()
	get_tree().current_scene.add_child(loading_instance)
	print("SCENE CHARGEMENT")

	await get_tree().process_frame  # Donne le temps d'afficher la scène de chargement

	# Charger la nouvelle scène en arrière-plan
	var new_scene = ResourceLoader.load(next_scene)
	if not new_scene:
		print("⚠ Erreur: Impossible de charger la scène " + next_scene)
		return # Arrete le programme en cas d'erreur

	# Changer de scène
	get_tree().current_scene.queue_free()  # Supprime l’ancienne scène
	await get_tree().process_frame  # Attendre un frame pour éviter des conflits
	# Mettre la nouvelle scène en place
	get_tree().change_scene_to_packed(new_scene)


	# Supprimer la scène de chargement
	loading_instance.queue_free()
	is_loading = false  # Réactive l'interaction après le chargement
