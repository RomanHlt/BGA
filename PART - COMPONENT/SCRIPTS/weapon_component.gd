extends Node2D
class_name  WeaponComponent

var bullet_scene = preload("res://PART - PLAYER/SCENES/bullet.tscn")
@export var sprite:Sprite2D

func _handle_fire(body:CharacterBody2D, fire:bool):
	if fire:
		var bullet = bullet_scene.instantiate()


		bullet.collision_layer = body.collision_layer
		bullet.collision_mask = body.collision_mask
		bullet.area.collision_layer = body.collision_layer
		bullet.area.collision_mask = body.collision_mask
		bullet.z_index = body.z_index
		if sprite.flip_h:
			bullet.position.x = body.position.x - $BulletSource.position.x
			bullet.position.y = body.position.y + $BulletSource.position.y
			bullet.scale.x = -1
		else:
			bullet.position = $BulletSource.position + body.position
		print(body.position)
		body.get_parent().add_child(bullet)
		bullet.apply_impulse(Vector2.ZERO, transform.x * 1000)  # Adjust the impulse as needed
