extends Control
signal SettingsClosed

var son:int = 50
var sonOn:bool = true

var music:int = 50
var musicOn:bool = true

var justArrived:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	#initialisation locale de sliders
	$HSlider.value = son
	$MusicSlider2.value = music
func _process(delta: float) -> void:
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("jump") and visible and !justArrived:
		for b in [$Back,$CheckButton,$MusicButton2]:
			if b.has_focus():
				b.emit_signal("pressed")
	elif justArrived:
		$Back.grab_focus()
		justArrived = false

#detection des boutons de ce menu
func _on_back_pressed() -> void:
	hide()
	emit_signal("SettingsClosed")


#Detection des actions manette
func _on_globals_options_controller_on() -> void:
	#On applique le focus
	if visible:
		$Back.grab_focus()

func _on_globals_options_controller_off() -> void:
	#On trouve et retire le focus
	for b in [$Back]:
		if b.has_focus and visible:
			b.release_focus()

#detection des autres menus
func _on_menu_pause_settings_opened() -> void:
	show()
	if Main.get_node("Globals Options").controller:
		justArrived = true



#Sliders --------------------------------
#Slider de son
func _on_h_slider_value_changed(value: float) -> void:
	son = value

func _on_check_button_pressed() -> void:
	sonOn = !sonOn
	if sonOn:
		$HSlider.editable = true
	else:
		$HSlider.editable = false
#slider de musique
func _on_music_slider_2_value_changed(value: float) -> void:
	music=value
func _on_music_button_2_pressed() -> void:
	musicOn= !musicOn
	if musicOn:
		$MusicSlider2.editable = true
	else:
		$MusicSlider2.editable = false
