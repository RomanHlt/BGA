extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Main.get_node("Globals Options").ingame: # On vérifie que le joueur soit bien en jeu
		show()
	else:
		hide()
	
	$InGame/lifeController.play(str(PlayerDataSaver.PlayerStats.health))
