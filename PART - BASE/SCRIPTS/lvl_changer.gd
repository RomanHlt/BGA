extends Area2D

@export_category("Self config")
@export var layer: int  # Layer de l'objet
@export var sprite: Texture2D  # Sprite de l'objet avec lequel interagir
@export var texte: String = "Appuyez sur [E] pour utiliser l'échelle"  # Texte affiché
@export_category("Next lvl config")
@export var id_next_lvl: String
@export_category("LoadScreen config")
@export var titre : String
@export var sous_titre : String


@onready var can_interact = false  # Peut-on interagir ?
var is_loading = false  # Empêche de spammer le changement de scène

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script ne sera pas afecté par les pauses.
	$Panel/Label.text = texte
	collision_layer = 0
	z_index = -layer
	collision_mask = 2**layer
	if sprite:
		$Sprite2D.texture = sprite
	else:
		if $Sprite2D.texture == null:
			print("⚠ Aucune texture assignée à l'objet !")

func _on_body_entered(body: Node2D) -> void:
	"""Affiche le texte d'interaction"""
	if body.name == "Player":
		$Panel.visible = true
		can_interact = true

func _on_body_exited(body: Node2D) -> void:
	"""Cache le texte d'interaction"""
	if body.name == "Player":
		$Panel.visible = false
		can_interact = false

func _input(event: InputEvent) -> void:
	"""Déclenche le changement de niveau"""
	if Input.is_action_just_pressed("interagir") and can_interact:
		PlayerDataSaver.WorldStats.level_completed(id_next_lvl)
		Main.get_node("Globals Levels").change_lvl(id_next_lvl, titre, sous_titre)
