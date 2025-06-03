extends Label

@export var timer:float
@export var chronoOn:bool = false

func _process(delta : float):
	if Main.get_node("CanvasLayer/Menus/MenuSettings").speedRun and chronoOn :
		timer += delta
		#temps en secondes, avec 3 décimales
		self.text = String.num(timer, 3) 
	text = str(snappedf(timer,0.01))
	
	if PlayerDataSaver.PlayerStats.current_lvl == "999.0.0":
		stop()
		Main.get_node("CanvasLayer/Menus").hide()

func start():
	reset()
	chronoOn = true
	if Main.get_node("CanvasLayer/Menus/MenuSettings").speedRun:
		show()

func stop():
	chronoOn = false

func reset():
	timer = 0.0

func _on_menu_accueil_start() -> void:
	start()
