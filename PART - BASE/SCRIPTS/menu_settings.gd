extends Control
signal SettingsClosed
signal SettingsToMenu
signal openControls

@export var musicPlayer:AudioStreamPlayer

var son:int = -30
var sonOn:bool = true

var music:int = -30
var musicOn:bool = true


var speedRun:bool = false

var justArrived:bool = false

var buttons = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	buttons = [$Back,$Controls,$CheckButton,$MusicButton2,$CheckBox]
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	hide()
	#initialisation locale de sliders
	$HSlider.value = son
	$MusicSlider2.value = music

func _process(delta: float) -> void:
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("ok") and visible and !justArrived:
		for b in buttons:
			if b.has_focus():
				print(b)
				b.emit_signal("pressed")
	elif justArrived:
		$Back.grab_focus()
		justArrived = false
	
	if Main.get_node("Globals Options").onMenu:
		$CheckBox.disabled = false
		buttons = [$Back,$Controls,$CheckButton,$MusicButton2,$CheckBox]
	else:
		$CheckBox.disabled = true
		buttons = [$Back,$Controls,$CheckButton,$MusicButton2]
	
	#actualisation de la musique
	if visible:
		if !musicOn: musicPlayer.volume_db = -80
		else:
			musicPlayer.volume_db = music

#detection des boutons de ce menu
func _on_controls_pressed() -> void:
	hide()
	emit_signal("openControls")
	
func _on_back_pressed() -> void:
	hide()
	if Main.get_node("Globals Options").onMenu:
		emit_signal("SettingsToMenu")
	else:
		emit_signal("SettingsClosed")


func _on_check_box_pressed() -> void:
	speedRun = ! speedRun
	if speedRun:
		$CheckBox.button_pressed = true
	else:
		$CheckBox.button_pressed = false

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

func _on_menu_accueil_settings_from_menu() -> void:
	show()
	if Main.get_node("Globals Options").controller:
		justArrived = true

func _on_menu_controls_controls_closed() -> void:
	show()
	Main.get_node("/root/Map/TileMapLayer/Player").position.x = 1109
	Main.get_node("/root/Map/TileMapLayer/Player").position.y = -325
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
		$CheckButton.button_pressed = true
	else:
		$HSlider.editable = false
		$CheckButton.button_pressed = false
#slider de musique
func _on_music_slider_2_value_changed(value: float) -> void:
	music=value
func _on_music_button_2_pressed() -> void:
	musicOn= !musicOn
	if musicOn:
		$MusicSlider2.editable = true
		$MusicButton2.button_pressed = true
	else:
		$MusicSlider2.editable = false
		$MusicButton2.button_pressed = false
