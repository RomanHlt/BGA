extends Control

func _ready() -> void:
	Main.get_node("CanvasLayer/Menus/MenuPause").canOpen = false

func _on_retour_au_menu_pressed() -> void:
	Main.get_node("Globals Levels").change_lvl("0.0.0", "Retour au Menu","")
	hide()
	Main.get_node("Globals Options").controller = false
	Main.get_node("Globals Options").onMenu = true


func _on_button_pressed() -> void:
	JavaScriptBridge.eval("window.open('https://www.instagram.com/insa.bga/', '_blank')")
