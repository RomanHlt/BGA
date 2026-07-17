extends Line2D


@export var offset : Vector2 = Vector2(0,-8)
@onready var last_pos : Vector2 = Vector2.ZERO
@onready var target = get_tree().root.get_node("Map").player # Player par defaut

func _ready() -> void:
	last_pos = target.global_position + offset

func _process(_delta: float) -> void:
	z_index = target.z_index
	var pos = target.global_position + offset
	add_point(pos)
	if points.size() > 50:
		remove_point(0)
	last_pos = pos
