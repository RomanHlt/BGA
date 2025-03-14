extends CanvasLayer

func change_scene(target) -> void:
	$AnimationPlayer.play('dissolve')
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	 # Attente du chargement de la scène
	while ResourceLoader.load_threaded_get_status(target) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame  # Évite de bloquer le jeu
	$AnimationPlayer.play_backwards('dissolve')
