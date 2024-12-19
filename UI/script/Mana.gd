extends Node2D

var isVisible = true

func anime(n):
	"""Joue l'animation du mana n et change son état. Allumé <-> eteint"""
	isVisible = $"Sprite Statique".visible
	$"Sprite Statique".visible = false
	$"Sprite Anime".visible = true
	$AnimationPlayer.play("mana " + str(n))
	
func _on_animation_player_animation_finished(_anim_name):
	"""Change l'état du sprite statique (Visible ou non) une fois l'animation terminée.
	Prend en paramètre le nom de l'animation finie et l'état du sprite avant l'animation."""
	$"Sprite Anime".visible = false
	if not isVisible:
		$"Sprite Statique".visible = true
