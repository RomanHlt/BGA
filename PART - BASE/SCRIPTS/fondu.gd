extends ColorRect


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.

func change_lvl(path, titre, sous_titre):
	Main.get_node("/root/GlobalsOptions").ingame = false
	$Titre.text = titre
	$"Sous titre".text = sous_titre
	get_tree().paused = true
	$FonduPlayer.play("fondu")
	$LoadingPlayer.play("default")
	await $FonduPlayer.animation_finished
	get_tree().change_scene_to_file(path)
	await get_tree().create_timer(3).timeout
	$LoadingPlayer.stop()
	$FonduPlayer.play_backwards("fondu")
	get_tree().paused = false
	Main.get_node("/root/GlobalsOptions").ingame = true
