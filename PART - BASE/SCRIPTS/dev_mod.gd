extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(6).timeout
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $TextEdit.text == "jesuisdev":
		Main.get_node("Globals Options").is_dev = true
		Main.get_node("Globals Options").godmod_active = true
		Main.get_node("Globals Options").player.collision_layer = 0
		Main.get_node("Globals Options").player.collision_mask = 0
		Main.get_node("Globals Options").player.get_node("GravityComponent").gravity = 0
		self.queue_free()
	
