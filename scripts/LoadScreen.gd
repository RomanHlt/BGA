extends Control

@export var titre : String
@export var sous_titre : String


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script ne sera pas afecté par les pauses.
	$ColorRect/Titre.text = titre
	$"ColorRect/Sous titre".text = sous_titre
