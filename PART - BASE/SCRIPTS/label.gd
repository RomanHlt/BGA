extends Label

@export var text_keyboard : String
@export var text_controller : String


func _process(delta: float) -> void:
	if GlobalsOptions.controller:
		text = text_controller
	else:
		text = text_keyboard
