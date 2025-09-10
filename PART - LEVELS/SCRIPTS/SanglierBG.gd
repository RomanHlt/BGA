extends TileMapLayer

var Layers:Array = []
var x:int = 0
var map:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	map = get_parent()
	Layers = get_children()
	roll()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire"):
		roll()
	if Input.is_action_just_pressed("stats"):
		ejectPlayer()

func roll():
	if x == 2: x=0
	else: x+=1
	for i in range(len(Layers)):
		if i == x:
			Layers[i].enabled = true
		else:
			Layers[i].enabled = false

func ejectPlayer():
	if map.currentPlayerLayer == 1:
		map.goToLayer(0)
		map.player._takeDamages(0)
		map.player.stun(2)
		
