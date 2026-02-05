extends Node2D
@export var number:int = 1
@export var layer:int = 0
var map
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = self.owner
	$AnimationPlayer.play("Idle")
	$Area2D.collision_layer = 0
	#z_index = -layer
	$Area2D.collision_mask = 2**layer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print(PlayerDataSaver.WorldStats.compo[map.id])
		PlayerDataSaver.WorldStats.compo[map.id][number] = true
		hide()
		$AudioStreamPlayer.play()
		print(PlayerDataSaver.WorldStats.compo[map.id])



func _on_audio_stream_player_finished() -> void:
	queue_free()
