extends Control
signal settingsFromMenu
signal start
var justArrived = false
var virtualController:bool = false

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	if DisplayServer.is_touchscreen_available():
		$CheckBox.show()
		virtualController = true
		PlayerDataSaver.SettingsStats.runAsToggle = true
		Main.get_node("CanvasLayer/VirtualController").show()
	else:
		$CheckBox.hide()
		Main.get_node("CanvasLayer/VirtualController").hide()


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
	if virtualController:
		PlayerDataSaver.SettingsStats.runAsToggle = true
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
	#Main.get_node("/root/Map/TileMapLayer/Player").position.x = 1109
	#Main.get_node("/root/Map/TileMapLayer/Player").position.y = -325
	emit_signal("settingsFromMenu")

"""
187 72 Accueil
1109 -325 Settings
2143 -306 Settings/Controls
"""

func _on_new_game_pressed() -> void:
	if virtualController:
		PlayerDataSaver.SettingsStats.runAsToggle = true

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
	#Main.get_node("/root/Map/TileMapLayer/Player").position.x = 187
	#Main.get_node("/root/Map/TileMapLayer/Player").position.y = 72
	if Main.get_node("Globals Options").controller:
		$Load.grab_focus()


func _on_check_box_pressed() -> void:
	virtualController = !virtualController
	PlayerDataSaver.SettingsStats.runAsToggle = virtualController
	Main.get_node("CanvasLayer/VirtualController").visible = virtualController
