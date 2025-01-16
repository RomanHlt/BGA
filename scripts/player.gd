extends CharacterBody2D
signal pathObstrued


var deeperChecker
var closerChecker
var canGoDeeper:bool = true
var canGoCloser:bool = true


func _ready():
	#setup the layer checkers
	deeperChecker = $deeperChecker
	closerChecker = $closerChecker


func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


func lookAtLeft(dir:bool):
	if dir:
		$Sprite2D.flip_h = true
		$Sprite2D.offset.x = 4
	else:
		$Sprite2D.flip_h = false
		$Sprite2D.offset.x = 0


# Layer Checkers
func _on_area_2d_body_entered(body: Node2D) -> void:
	canGoDeeper = false
func _on_area_2d_body_exited(body: Node2D) -> void:
	canGoDeeper = true
func _on_closer_checker_body_entered(body: Node2D) -> void:
	canGoCloser = false
func _on_closer_checker_body_exited(body: Node2D) -> void:
	canGoCloser = true
