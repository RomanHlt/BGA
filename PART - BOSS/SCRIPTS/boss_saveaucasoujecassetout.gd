func _physics_process(delta):
	$GravityComponent.handle_gravity(self, delta) # Applique la gravité
	if is_following:
		follow_timer += delta
		
		# Gestion des Layers
		if target.collision_layer > self.collision_layer and can_go_deeper and not tried_jump_switch:
			change_layer(layer + 1)
		if target.collision_layer < self.collision_layer and can_go_closer and not tried_jump_switch and layer != 0:
			change_layer(layer - 1)
		
		# Calculer direction et mouvement
		var direction_x = sign(target.position.x - position.x)
		velocity.x = direction_x * speed # Que le x sinon on annule la gravité en écrasant la valeur en y
		
		# Si au sol et bloqué horizontalement → sauter
		if is_on_floor():
			var horizontal_speed = abs(global_position.x - last_position.x) / delta # abs(x) = |x|
			if horizontal_speed < 5:  # presque pas de mouvement
				stuck_timer += delta
				if stuck_timer >= stuck_check_delay and not tried_jump: # Si on attend trop longtemps et qu'on a pas déjà essayé, on saute
					$JumpComponent.handle_jump(self, true)
					tried_jump = true 
					stuck_timer = 0.0
				elif stuck_timer >= stuck_check_delay and tried_jump:
					
					if can_go_closer and layer != 0:
						change_layer(layer - 1)
					elif can_go_deeper:
						change_layer(layer + 1)
						
					elif can_go_closer_with_jump and tried_jump_switch == false and layer != 0:
						$JumpComponent.handle_jump(self, true)
						tried_jump_switch = true
						#await get_tree().create_timer(0.5).timeout # Par tatonnement, on est environ au sommet du saut pour une Jump velocity = -450
						await can_go_closer
						change_layer(layer - 1)
					elif can_go_deeper_with_jump and tried_jump_switch == false:
						$JumpComponent.handle_jump(self, true)
						tried_jump_switch = true
						#await get_tree().create_timer(0.5).timeout
						await can_go_deeper
						change_layer(layer + 1)
			else:
				stuck_timer = 0.0
				tried_jump = false
				tried_jump_switch = false

		# Activer la bonne collision de jump
		if direction_x == 1:
			$JumpLeft.hide()
			$JumpRight.show()
		else:
			$JumpLeft.show()
			$JumpRight.hide()

		# Calculer la distance parcourue depuis la dernière frame
		distance_traveled += global_position.distance_to(last_position)
		last_position = global_position

		# Conditions d'arrêt
		if (follow_timer >= following_time or distance_traveled >= following_distance) and is_on_floor():
			stop_follow()

	move_and_slide()
