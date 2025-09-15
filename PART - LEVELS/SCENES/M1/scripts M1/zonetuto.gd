extends Area2D

@onready var first_time = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and first_time:
		var children = get_tree().root.get_child(3).get_children()
		for child in children:
			if child.name == "Label1" or child.name == "Label2" or child.name == "Label5" or child.name == "Label6" or child.name == "Label7":
				child.visible = not child.visible


func _on_body_exited(body: Node2D) -> void:
	first_time = false
