extends Button

@export_category("Settings")
@export var map : PackedScene

func _on_pressed() -> void:
	get_tree().change_scene_to_packed(map)
	Main.get_node("Globals Options").ingame = true
