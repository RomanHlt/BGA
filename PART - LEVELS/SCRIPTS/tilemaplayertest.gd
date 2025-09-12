extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(5).timeout
	destroy_tile(Vector2i(7, 0))
	destroy_tile(Vector2i(7, -1))
	destroy_tile(Vector2i(6, 0))
	destroy_tile(Vector2i(6, -1))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func destroy_tile(cell: Vector2i) -> void:
	self.set_cell(cell, -1)  # -1 = aucune tuile
