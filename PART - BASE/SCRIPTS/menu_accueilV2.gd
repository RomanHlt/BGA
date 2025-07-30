extends Control
signal settingsFromMenu
signal start
var justArrived = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS


func _process(delta: float) -> void:
	if ! PlayerDataSaver.dataExist or Main.get_node("CanvasLayer/Menus/MenuSettings").speedRun:
		$Load.disabled = true
	else:
		$Load.disabled = false
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("ok") and visible and !justArrived:
		for b in [$Load,$Settings,$NewGame]:
			if b.has_focus():
				b.emit_signal("pressed")
	elif justArrived:
		$Load.grab_focus()
		justArrived = false

func _on_load_pressed() -> void:
	if PlayerDataSaver.dataExist:
		print("Load")
		var lvl = PlayerDataSaver.PlayerStats.current_lvl
		lvl = lvl[0] + ".0.0" # On respawn dans le hub du monde et pas en plein niveau (ca va éviter des bug au passage)
		if lvl == "9.0.0":lvl = "1.0.0"
		Main.get_node("Globals Levels").change_lvl(lvl, "Welcome Back",str(lvl))
		hide()
		Main.get_node("Globals Options").onMenu = false
		emit_signal("start")
	

func _on_settings_pressed() -> void:
	hide()
	emit_signal("settingsFromMenu")


func _on_new_game_pressed() -> void:
	PlayerDataSaver.dataExist = true
	PlayerDataSaver.PlayerStats = PlayerData.new()
	PlayerDataSaver.WorldStats = WorldData.new()
	var lvl = PlayerDataSaver.PlayerStats.current_lvl
	Main.get_node("Globals Levels").change_lvl(lvl, "Let's Begin",str(lvl))
	hide()
	Main.get_node("Globals Options").onMenu = false
	emit_signal("start")


#detection manette
func _on_globals_options_controller_on() -> void:
	if visible:
		$Load.grab_focus()

func _on_globals_options_controller_off() -> void:
	for b in [$Load,$Settings,$NewGame]:
		if b.has_focus and visible:
			b.release_focus()

#detection des autres menus

func _on_menu_settings_settings_to_menu() -> void:
	show()
	if Main.get_node("Globals Options").controller:
		$Load.grab_focus()
