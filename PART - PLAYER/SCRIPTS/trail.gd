extends Line2D

@export var offset: Vector2 = Vector2(0, -8)
@export var interval := 0.02 # 50 points par seconde
@onready var target = get_tree().root.get_node("Map").player

func _ready() -> void:
	var timer := Timer.new()
	timer.wait_time = interval
	timer.autostart = true
	timer.timeout.connect(_on_timer_timeout) # Quand le timer se fini on appel la fonction _on_timer_timeout
	add_child(timer)

func _process(_delta: float) -> void:
	z_index = target.z_index

func _on_timer_timeout() -> void:
	add_point(target.global_position + offset)

	if points.size() > 30:
		remove_point(0)
