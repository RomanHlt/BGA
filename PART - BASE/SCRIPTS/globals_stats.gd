extends Control


func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.

# Variables stats et Progrès
var nb_sauts = 0

func _input(event: InputEvent) -> void:
	# Stats
	if event.is_action_pressed("jump"):
		nb_sauts += 1
