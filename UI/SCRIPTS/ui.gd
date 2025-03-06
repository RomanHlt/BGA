extends Control

@onready var manas = get_child(0).get_child(0).get_children()

func _ready() -> void:
	"""Initialise les textures de chaque instance des scene 'Mana i'."""
	for i in range(5):
		manas[i].get_child(0).texture = load("res://art/format png/mana " + str(i) + " stat.png")

func change_mana(n):
	manas[n].anime(n)



func _input(event: InputEvent) -> void:
	"""[FONCTION TEST A SUPPRIMER] | Test de l'UI du mana"""
	if event.is_action_pressed("ui_down"):
		start_animations()

func start_animations():
	"""[FONCTION TEST A SUPPRIMER] | Juste pour flex sur trois pixel qui clignottent"""
	change_mana(0)
	await get_tree().create_timer(0.1).timeout
	change_mana(1)
	await get_tree().create_timer(0.1).timeout
	change_mana(2)
	await get_tree().create_timer(0.1).timeout
	change_mana(3)
	await get_tree().create_timer(0.1).timeout
	change_mana(4)
