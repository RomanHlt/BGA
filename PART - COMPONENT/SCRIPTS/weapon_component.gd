extends Node2D
class_name  WeaponComponent

var bullet_scene = preload("res://PART - PLAYER/SCENES/bullet.tscn")


func _handle_fire(body:CharacterBody2D, fire:bool):
	if fire:
		var bullet = bullet_scene.instantiate()
		bullet.position = $BulletSource.position + body.position

		bullet.scale = body.scale  # Align bullet with player's rotation
		bullet.collision_layer = body.collision_layer
		bullet.collision_mask = body.collision_mask
		bullet.area.collision_layer = body.collision_layer
		bullet.area.collision_mask = body.collision_mask
		bullet.z_index = body.z_index
		body.get_parent().add_child(bullet)
		bullet.apply_impulse(Vector2.ZERO, transform.x * 1000)  # Adjust the impulse as needed
