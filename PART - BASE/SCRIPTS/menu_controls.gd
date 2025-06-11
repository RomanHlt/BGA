extends Control
signal inputReceived
signal controllerReceived

signal ControlsClosed

var runToggle:bool = false

var lastInput:String
var lastEvent:InputEvent
var lastCode:int

var justArrived:bool = false
var buttons = []
var controllerButtons = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if PlayerDataSaver.dataExist:
		
		runToggle = PlayerDataSaver.SettingsStats.runAsToggle
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	buttons = [$Right,$Left,$Deeper,$Closer,$Jump]
	controllerButtons = [$ControllerCloser,$ControllerDeeper,$ControllerJump,$ControllerRun]
	updateControls()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("ok") and visible and !justArrived:
		for b in controllerButtons+[$Reset,$Back, $"Run Toggle"]:
			if b.has_focus() and b.disabled == false:
				b.emit_signal("pressed")
	elif justArrived:
		_on_globals_options_controller_on()
		justArrived = false

func findKey(action:String)->String:
	var events = InputMap.action_get_events(action).filter(func (x): if x is InputEventKey:return x)
	if events != []:
		return events[0].as_text()
	else: return "---"
func findKeyController(action:String)->String:
	var events = InputMap.action_get_events(action).filter(func (x): if (x is InputEventJoypadButton) or (x is InputEventJoypadMotion):return x)
	if events != []:
		return events[0].as_text().split("(")[1].split(")")[0]
	else: return "---"


func updateControls():
	$Right.text="Move Right: " + findKey("move_right")
	$Left.text="Move Left: " + findKey("move_left")
	$Deeper.text="Jump Deeper: " + findKey("deeperLayer")
	$Closer.text="Jump Closer: " + findKey("closerLayer")
	$Jump.text="Jump: "+ findKey("jump")
	$ControllerDeeper.text="Jump Deeper: " + findKeyController("deeperLayer")
	$ControllerCloser.text="Jump Closer: " + findKeyController("closerLayer")
	$ControllerJump.text="Jump: " + findKeyController("jump")
	$ControllerRun.text="Run: " + findKeyController("run")

	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		lastInput = event.as_text_keycode()
		lastCode = event.keycode
		lastEvent = event
		emit_signal("inputReceived")
	elif event is InputEventJoypadButton:
		lastEvent = event
		emit_signal("controllerReceived")
	elif event is InputEventJoypadMotion:
		if event.axis_value>=0.70:
			lastEvent = event
			emit_signal("controllerReceived")
	elif event is InputEventMouseButton:
		lastCode = event.button_index
		lastInput = "MOUSE"
		#emit_signal("inputReceived")
		lastEvent = event

#Ecouter la prochaine touche pressée et l'appliquer au bouton concerné
func Listen(b:Button,action:String):
	b.disabled = true
	await inputReceived
	b.disabled = false
	#On trouve la key actuelle (A FAIRE: Adapter le type d'event à supr au type d'event écouté)
	var keyToDel:InputEventKey = null 
	for i in InputMap.action_get_events(action): if i is InputEventKey:keyToDel=i
	#On la supprime
	InputMap.action_erase_event(action,keyToDel)
	#On ajoute l'action enregistrée
	InputMap.action_add_event(action,lastEvent)
	print(InputMap.action_get_events(action))
	updateControls()

func ListenController(b:Button,action:String):
	await get_tree().create_timer(0.5).timeout
	lastCode = 0
	lastInput = ""
	b.disabled = true
	await controllerReceived
	b.disabled = false
	#On trouve la key actuelle (A FAIRE: Adapter le type d'event à supr au type d'event écouté)
	var keyToDel = null 
	for i in InputMap.action_get_events(action): 
		if (i is InputEventJoypadButton) or (i is InputEventJoypadMotion):
			keyToDel=i
	#On la supprime
	InputMap.action_erase_event(action,keyToDel)
	#On ajoute l'action enregistrée
	InputMap.action_add_event(action,lastEvent)
	print(InputMap.action_get_events(action))
	updateControls()
#Paramètre de chaque touche
func _on_right_pressed() -> void:
	Listen($Right,"move_right")	


func _on_left_pressed() -> void:
	Listen($Left,"move_left")


func _on_deeper_pressed() -> void:
	Listen($Deeper,"deeperLayer")


func _on_closer_pressed() -> void:
	Listen($Closer,"closerLayer")


func _on_jump_pressed() -> void:
	Listen($Jump,"jump")

#Parametre des touches controller

func _on_controller_deeper_pressed() -> void:
	ListenController($ControllerDeeper,"deeperLayer")

func _on_controller_closer_pressed() -> void:
	ListenController($ControllerCloser, "closerLayer")

func _on_controller_jump_pressed() -> void:
	ListenController($ControllerJump, "jump")


func _on_controller_run_pressed() -> void:
	ListenController($ControllerRun, "run")

#Autres Boutons du menu
func _on_back_pressed() -> void:
	hide()
	emit_signal("ControlsClosed")

func _on_reset_pressed() -> void:
	InputMap.load_from_project_settings()
	updateControls()

func _on_run_toggle_pressed() -> void:
	runToggle = !runToggle
	$"Run Toggle".button_pressed = runToggle
	PlayerDataSaver.SettingsStats.runAsToggle = runToggle

#Detection des autres menus
func _on_menu_settings_open_controls() -> void:
	show()
	if Main.get_node("Globals Options").controller:
		justArrived = true

#Detection des actions manette
func _on_globals_options_controller_on() -> void:
	#On applique le focus
	if visible:
		$Back.grab_focus()
		for b:Button in buttons:
			b.disabled = true
		for b:Button in controllerButtons:
			b.disabled = false

func _on_globals_options_controller_off() -> void:
	#On trouve et retire le focus
	for b:Button in buttons + [$Back,$Reset,$"Run Toggle"]:
		b.disabled = false
		if b.has_focus and visible:
			b.release_focus()
	for b:Button in controllerButtons:
		b.disabled = true
		if b.has_focus and visible:
			b.release_focus()
