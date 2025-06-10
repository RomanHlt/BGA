extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not PlayerDataSaver.is_new_game:
		hide()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		PlayerDataSaver.is_new_game = false
		hide()
