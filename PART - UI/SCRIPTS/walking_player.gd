extends Node2D
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = load("res://PART - PLAYER/SCENES/EmptyPlayer.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$Path2D/PathFollow2D.progress += 250 * delta
	

func _on_timer_timeout() -> void:
	#add_child(player)
	pass
