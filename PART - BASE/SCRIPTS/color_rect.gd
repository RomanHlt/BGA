extends ColorRect


func dead():
	$AnimationPlayer.play("Dead")
	await get_tree().create_timer(1.5).timeout
	$AnimationPlayer.play_backwards("Dead")
