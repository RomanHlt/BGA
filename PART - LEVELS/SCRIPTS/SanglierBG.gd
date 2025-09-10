extends TileMapLayer

var Layers:Array = []
var x:int = 0
var map:Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	map = get_parent()
	roll()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func roll():
	if x == 2: x=0
	else: x+=1
	if x==0:
		position.x = 0
	if x==1:
		position.x = -752
	if x==2:
		position.x = -1504



func ejectPlayer():
	if map.currentPlayerLayer == 1:
		map.goToLayer(0)
		map.player._takeDamages(0)
		map.player.stun(2)
		
