extends CanvasLayer

var refill:bool = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var lvl = PlayerDataSaver.PlayerStats.current_lvl

	if lvl.split(".")[1] !="0": # On vérifie que le joueur soit bien en jeu et hors d'un boss
		show()
		var n =""
		for i in PlayerDataSaver.WorldStats.compo[lvl]:
			if i:
				n+="1"
			else:
				n+="0"
		$InGame/NotesCount/NotesPlayer.play(n)
		
		
	else:
		hide()
		$InGame/NotesCount/NotesPlayer.play("000")
	
	$InGame/lifeController.play(str(PlayerDataSaver.PlayerStats.health))
	
	if refill:
		$InGame/TextureDash.value = (1.5-$InGame/TextureDash/Timer.time_left)*100/1.5
		if $InGame/TextureDash.value == 100:
			refill = false
	
	# C'est stylé mais obligé de vérifier à chaque frame ?? A vérifier si on veut opti
	if Main.get_node("Globals Options").controller:
		$InGame/Label.text = "C"
	else:
		$InGame/Label.text = "K"
	
	if PlayerDataSaver.PlayerStats.dashUnlocked and $InGame/TextureDash.value == 0:
		$InGame/TextureDash/Timer.start()
		refill = true
		
	if lvl.split(".")[1] == "4":
		$InGame/NotesCount.hide()

func reloadDash():
	$InGame/TextureDash.value = 0
