extends Control

var a:InputEventAction
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()
	a = InputEventAction.new()
	a.action = "interact"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_right_pressed() -> void:
	Main.get_node("Globals Options").player.direction = 1


func _on_right_released() -> void:
	Main.get_node("Globals Options").player.direction = 0


func _on_left_pressed() -> void:
	Main.get_node("Globals Options").player.direction = -1


func _on_left_released() -> void:
	Main.get_node("Globals Options").player.direction = 0


func _on_jump_pressed() -> void:
	Main.get_node("Globals Options").player.virtualJumpPressed = true


func _on_jump_released() -> void:
	Main.get_node("Globals Options").player.virtualJumpReleased = true


func _on_closer_pressed() -> void:
	Input.action_press("closerLayer")


func _on_closer_released() -> void:
	Input.action_release("closerLayer")


func _on_deeper_pressed() -> void:
	Input.action_press("deeperLayer")


func _on_deeper_released() -> void:
	Input.action_release("deeperLayer")


func _on_interact_pressed() -> void:
	Input.action_press("interagir")


func _on_interact_released() -> void:
	Input.action_release("interagir")
