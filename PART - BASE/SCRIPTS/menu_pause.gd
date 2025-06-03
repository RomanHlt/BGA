extends Control
signal SettingsOpened
signal BackTitle

var canOpen:bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	$Resume.release_focus()
	$Quit.release_focus()
	$Settings.release_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("menu") and canOpen:
		visible = ! visible
		if visible:
			get_tree().paused = true
			if Main.get_node("Globals Options").controller:
				_on_globals_options_controller_on()
		else:
			get_tree().paused = false
			if Main.get_node("Globals Options").controller:
				_on_globals_options_controller_off()
				Main.get_node("Globals Options").controller = false
	
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("jump") and visible:
		for b in [$Resume,$Settings,$Quit]:
			if b.has_focus():
				b.emit_signal("pressed")
				print(b)


#Detection des boutons de ce menu
func _on_resume_pressed() -> void:
	get_tree().paused = false
	hide()

func _on_quit_pressed() -> void:
	if PlayerDataSaver.PlayerStats.current_lvl.split(".")[1] != "0":
		var hub:String = PlayerDataSaver.PlayerStats.current_lvl.split(".")[0]+".0.0"
		Main.get_node("Globals Levels").change_lvl(hub, "Retour au Hub",hub)
		hide()
		Main.get_node("Globals Options").controller = false
	else:
		Main.get_node("Globals Levels").change_lvl("0.0.0", "Retour au Menu","")
		hide()
		Main.get_node("Globals Options").controller = false
		Main.get_node("Globals Options").onMenu = true


func _on_settings_pressed() -> void:
	hide()
	emit_signal("SettingsOpened")
	canOpen = false


#Detection des actions manette
func _on_globals_options_controller_on() -> void:
	#On applique le focus
	if visible:
		$Resume.grab_focus()

func _on_globals_options_controller_off() -> void:
	#On trouve et retire le focus
	for b in [$Resume,$Settings,$Quit]:
		if b.has_focus and visible:
			b.release_focus()

#Detection des autres menus
func _on_menu_settings_settings_closed() -> void:
	show()
	if Main.get_node("Globals Options").controller:
		$Resume.grab_focus()
	canOpen = true
