extends Control

var a:InputEventAction
var run:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


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


func _on_button_button_down() -> void:
	if Main.get_node("CanvasLayer/Menus/MenuAccueil").visible == false and Main.get_node("CanvasLayer/Menus/MenuPause").visible == false:
		Input.action_press("menu")

func _on_button_button_up() -> void:
	Input.action_release("menu")


func _on_run_toggle_pressed() -> void:
	run = !run
	Input.action_press("run")

func _on_run_toggle_released() -> void:
	Input.action_release("run")
