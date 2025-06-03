extends Control
signal inputReceived

var lastInput:String
var lastCode:int
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Label.text = lastInput+" | "+str(lastCode)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		lastInput = event.as_text_keycode()
		lastCode = event.keycode
		emit_signal("inputReceived")
	elif event is InputEventJoypadButton:
		print("Button")
	elif event is InputEventMouseButton:
		lastCode = event.button_index
		lastInput = "MOUSE"
		emit_signal("inputReceived")

#Ecouter la prochaine touche pressée et l'appliquer au bouton concerné
func Listen(b:Button):
	lastCode = 0
	lastInput = ""
	b.disabled = true
	await inputReceived
	b.text = lastInput+" | "+str(lastCode)
	b.disabled = false


func _on_right_pressed() -> void:
	Listen($Right)


func _on_left_pressed() -> void:
	Listen($Left)


func _on_deeper_pressed() -> void:
	Listen($Deeper)


func _on_closer_pressed() -> void:
	Listen($Closer)


func _on_jump_pressed() -> void:
	Listen($Jump)
