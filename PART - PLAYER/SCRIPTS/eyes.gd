extends Line2D

var last_pos : Vector2 = Vector2.ZERO
var r : float = 6
func _ready() -> void:
	last_pos = get_parent().global_position



func _process(_delta: float) -> void:
	var pos = get_parent().global_position
	var dir = (pos - last_pos).normalized()
	add_point(pos - r * dir)
	if points.size() > 100:
		remove_point(0)
	
	last_pos = pos
