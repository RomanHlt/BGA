extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_right_button_down() -> void:
	Main.get_node("Globals Options").player.direction = 1


func _on_right_button_up() -> void:
	Main.get_node("Globals Options").player.direction = 0

func _on_left_button_down() -> void:
	Main.get_node("Globals Options").player.direction = -1


func _on_left_button_up() -> void:
	Main.get_node("Globals Options").player.direction = 0



func _on_up_button_down() -> void:
	Main.get_node("Globals Options").player.virtualJumpPressed = true


func _on_up_button_up() -> void:
	Main.get_node("Globals Options").player.virtualJumpReleased = true


func _on_deeper_button_down() -> void:
	Input.action_press("deeperLayer")

func _on_deeper_button_up() -> void:
	Input.action_release("deeperLayer")

func _on_closer_button_down() -> void:
	Input.action_press("closerLayer")

func _on_closer_button_up() -> void:
	Input.action_release("closerLayer")
