extends CanvasLayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lvl = PlayerDataSaver.PlayerStats.current_lvl

	if lvl.split(".")[1] !="0": # On vérifie que le joueur soit bien en jeu
		show()
		var n =""
		for i in PlayerDataSaver.WorldStats.compo[int(lvl.split(".")[1])]:
			if i:
				n+="1"
			else:
				n+="0"
		$InGame/NotesCount/NotesPlayer.play(n)
		
		
	else:
		hide()
		$InGame/NotesCount/NotesPlayer.play("000")
	
	$InGame/lifeController.play(str(PlayerDataSaver.PlayerStats.health))
	
	if Main.get_node("Globals Options").controller:
		$InGame/Label.text = "C"
	else:
		$InGame/Label.text = "K"
