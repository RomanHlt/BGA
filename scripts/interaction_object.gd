extends Area2D

@export var sprite: Texture2D  # Sprite de l'objet avec lequel interagir
@export var texte: String = "Appuyez sur [E] pour interagir"  # Texte affiché lorsqu'on s'approche
@export var scene: PackedScene  # Scène à afficher en cas d'interaction
@export var layer: int  # Layer de l'objet

@onready var panel = $Panel # Texte d'interaction
@onready var can_interact = false  # Peut-on interagir ?
@onready var is_open = false  # La scène d'interaction est-elle ouverte ?
@onready var scene_instance: Node = null  # Stocke l'instance de la scène ouverte

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
	"""Possibilité d'interagir et affichage du texte"""
	panel.visible = true
	can_interact = true

func _on_body_exited(body: Node2D) -> void:
	"""Plus de possibilité d'interagir et disparition du texte"""
	panel.visible = false
	can_interact = false
	if scene_instance and is_instance_valid(scene_instance):
				scene_instance.queue_free()  # Supprime la scène

func _input(event: InputEvent) -> void:
	"""Ouvrir/Fermer la scène d'interaction"""
	if Input.is_action_just_pressed("interagir") and can_interact:
		if not is_open:
			if scene:
				get_tree().paused = true
				scene_instance = scene.instantiate()  # Instancie la scène
				scene_instance.tree_exited.connect(_on_scene_instance_tree_exited)  # Détecte suppression
				get_tree().current_scene.add_child(scene_instance)  # Ajoute la scène
				is_open = true
			else:
				print("⚠ Aucune scène assignée pour l'interaction !")
		else:
			if scene_instance and is_instance_valid(scene_instance):
				get_tree().paused = false
				scene_instance.queue_free()  # Supprime la scène

func _on_scene_instance_tree_exited() -> void:
	"""Appelé quand la scène est supprimée"""
	is_open = false
	scene_instance = null  # Bien remettre à null pour éviter une recréation immédiate
