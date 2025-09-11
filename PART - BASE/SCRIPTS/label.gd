extends Label

@export var text_keyboard : String
@export var text_controller : String
@export var color_hex : String = "ee9be3"

func _ready() -> void:
	self.add_theme_color_override("font_color", color_hex)
	

func _process(delta: float) -> void:
	if Main.get_node("Globals Options").controller:
		text = text_controller
	else:
		text = text_keyboard
