extends CanvasLayer

func _ready() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script autoload ne sera pas afecté par les pauses.

func change_scene(target) -> void:
	
	get_tree().paused = true
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	 # Attente du chargement de la scène
	while ResourceLoader.load_threaded_get_status(target) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame  # Évite de bloquer le jeu
	await get_tree().create_timer(5.0).timeout  # Attend 5 secondes
	end_change()
	
func end_change():
	get_tree().paused = false
	$AnimationPlayer.play_backwards('dissolve')
	
func modification(titre, sous_titre):
	$dissolve_rect/Titre.text = titre
	$"dissolve_rect/Sous titre".text = sous_titre
