extends Button

@export_category("Settings")
@export var map : PackedScene

func _on_pressed() -> void:
	Main.get_node("Globals Levels").change_lvl("1.0.0", "HUB", "Go hub")
