extends Control


var justArrived = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("jump") and visible and !justArrived:
		for b in [$Load,$Settings,$NewGame]:
			if b.has_focus():
				b.emit_signal("pressed")
	elif justArrived:
		$Load.grab_focus()
		justArrived = false

func _on_load_pressed() -> void:
	print("Load")
	var lvl = PlayerDataSaver.PlayerStats.current_lvl
	Main.get_node("Globals Levels").change_lvl(lvl, "Welcome Back",str(lvl))
	hide()


func _on_new_game_pressed() -> void:
	PlayerDataSaver.PlayerStats = PlayerData.new()
	PlayerDataSaver.WorldStats = WorldData.new()
	var lvl = PlayerDataSaver.PlayerStats.current_lvl
	Main.get_node("Globals Levels").change_lvl(lvl, "Let's Begin",str(lvl))
	hide()

#detection manette
func _on_globals_options_controller_on() -> void:
	if visible:
		$Load.grab_focus()

func _on_globals_options_controller_off() -> void:
	for b in [$Load,$Settings,$NewGame]:
		if b.has_focus and visible:
			b.release_focus()
