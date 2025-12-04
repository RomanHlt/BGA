extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextEdit.grab_focus()
	await get_tree().create_timer(6).timeout
	$TextEdit.release_focus()
	if Main.get_node("Globals Options").is_dev == false:
		self.queue_free()

var main = Main.get_node("Globals Options")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $TextEdit.text == "ytreza":
		$TextEdit.hide()
		$Access.show()
		$GodMod.show()
		$"Unlock Power".show()
		main.is_dev = true
	if get_tree().root.get_node("Map"):
		if get_tree().root.get_node("Map").id == "1.4.0" and main.is_dev:
			$End_CVL.show()
		else:
			$End_CVL.hide()

func _on_button_pressed() -> void:
	$"Unlock Power".release_focus()
	if main.full_access:
		main.full_access = false
	else:
		main.full_access = true


func _on_god_mod_pressed() -> void:
	$GodMod.release_focus()
	if main.godmod_active:
		main.player.collision_layer = 2**get_tree().current_scene.currentPlayerLayer
		main.player.collision_mask = 2**get_tree().current_scene.currentPlayerLayer
		main.player.get_node("GravityComponent").gravity = 1200
		main.godmod_active = false
	else:
		main.player.collision_layer = 0
		main.player.collision_mask = 0
		main.player.get_node("GravityComponent").gravity = 0
		main.godmod_active = true


func _on_unlock_power_pressed() -> void:
	$"Unlock Power".release_focus()
	PlayerDataSaver.PlayerStats.dashUnlocked = PlayerDataSaver.PlayerStats.dashUnlocked == false


func _on_end_cvl_pressed() -> void:
	$End_CVL.release_focus()
	get_tree().root.get_node("Map").get_node("TileMapLayer2").end()
