extends TileMapLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(2).timeout
	#destroy_tile(Vector2i(49, -3))
	destroy_tile(Vector2i(50, -2))
	#destroy_tile(Vector2i(49, -2))
	#destroy_tile(Vector2i(50, -3))
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func destroy_tile(cell: Vector2i) -> void:
	print(cell)
	print(self.get_cell_tile_data(cell))
	self.get_cell_tile_data(cell).modulate.a = 0.5
