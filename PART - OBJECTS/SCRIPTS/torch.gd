extends Node2D


@export_category("Visuals Settings")
@export var colors : Array = ["ff0000","ff1200","ff1d00","ff2800"]
@export var shadow_color : String = "00000000"
@export var power : int = 2
@export var tex_scale : float = 1
@export_category("Global Settings")
@export var layer : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationPlayer.play("default")
	$PointLight2D.range_item_cull_mask = 2**layer + 2**(layer+1)
	$PointLight2D.shadow_item_cull_mask = 2**layer
	$PointLight2D.color = colors[0]
	$PointLight2D.shadow_color = shadow_color
	$PointLight2D.energy = power
	$PointLight2D.texture_scale = tex_scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_timer_timeout() -> void:
	$PointLight2D.texture_scale = tex_scale + randf_range(-0.201,0.201)
	$PointLight2D.color = colors[randi_range(0,len(colors)-1)]
