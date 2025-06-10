extends Control
signal inputReceived
signal ControlsClosed

var lastInput:String
var lastEvent:InputEvent
var lastCode:int

var justArrived:bool = false
var buttons = []
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	buttons = [$Back,$Right,$Left,$Deeper,$Closer,$Jump]
	updateControls()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = lastInput+" | "+str(lastCode)
	#Detection de l'action du joueur
	if Input.is_action_just_pressed("jump") and visible and !justArrived:
		for b in buttons:
			if b.has_focus():
				b.emit_signal("pressed")
	elif justArrived:
		$Back.grab_focus()
		justArrived = false
func findKey(action:String)->String:
	var events = InputMap.action_get_events(action).filter(func (x): if x is InputEventKey:return x)
	if events != []:
		return events[0].as_text()
	else: return "---"
func updateControls():
	$Right.text="Move Right: " + findKey("move_right")
	$Left.text="Move Left: " + findKey("move_left")
	$Deeper.text="Jump Deeper: " + findKey("deeperLayer")
	$Closer.text="Jump Closer: " + findKey("closerLayer")
	$Jump.text="Jump: "+ findKey("jump")
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		lastInput = event.as_text_keycode()
		lastCode = event.keycode
		lastEvent = event
		emit_signal("inputReceived")
	elif event is InputEventJoypadButton:
		print("Button")
	elif event is InputEventMouseButton:
		lastCode = event.button_index
		lastInput = "MOUSE"
		#emit_signal("inputReceived")
		lastEvent = event

#Ecouter la prochaine touche pressée et l'appliquer au bouton concerné
func Listen(b:Button,name:String,action:String,key:int):
	lastCode = 0
	lastInput = ""
	b.disabled = true
	await inputReceived
	b.text = name + ": " + lastInput
	b.disabled = false
	#On trouve la key actuelle (A FAIRE: Adapter le type d'event à supr au type d'event écouté)
	var keyToDel:InputEventKey = null 
	for i in InputMap.action_get_events(action): if i is InputEventKey:keyToDel=i
	#On la supprime
	InputMap.action_erase_event(action,keyToDel)
	#On ajoute l'action enregistrée
	InputMap.action_add_event(action,lastEvent)
	print(InputMap.action_get_events(action))
#Paramètre de chaque touche
func _on_right_pressed() -> void:
	Listen($Right,"Move Right","move_right",0)	


func _on_left_pressed() -> void:
	Listen($Left, "Move Left","move_left",0)


func _on_deeper_pressed() -> void:
	Listen($Deeper, "Jump Deeper","deeperLayer",0)


func _on_closer_pressed() -> void:
	Listen($Closer, "Jump Closer","closerLayer",0)


func _on_jump_pressed() -> void:
	Listen($Jump, "Jump","jump",0)

#Autres Boutons du menu
func _on_back_pressed() -> void:
	hide()
	emit_signal("ControlsClosed")

func _on_reset_pressed() -> void:
	InputMap.load_from_project_settings()
	updateControls()

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

func _on_globals_options_controller_off() -> void:
	#On trouve et retire le focus
	for b in [$Back]:
		if b.has_focus and visible:
			b.release_focus()
