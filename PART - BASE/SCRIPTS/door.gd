class_name Door extends Area2D

@export_category("Self config")
@export var layer: int  # Layer de l'objet
@export var sprite: Texture2D  # Sprite de l'objet avec lequel interagir
@export var texte: String = "[E]"  # Texte affiché
@export var textController:String = ""
@export var isHub:bool = true
@export_category("Level config")
@export var id_next_lvl: String #Monde.Niveau.Sous-Niveau
@export var id_last_lvl: String 
@export var id_unlocked_lvl:String
@export_category("LoadScreen config")
@export var titre : String
@export var sous_titre : String


@onready var can_interact = false  # Peut-on interagir ?qd
var is_loading = false  # Empêche de spammer le changement de scène

var notes = [false,false,false]
var canAccess = false


func _ready() -> void:
	$AnimationPlayer.get_animation("Opening").loop_mode = Animation.LOOP_NONE #rend l'animation unique

	self.process_mode = Node.PROCESS_MODE_ALWAYS # Le script ne sera pas afecté par les pauses.
	
	if PlayerDataSaver.PlayerStats.last_lvl == id_last_lvl:
		$AnimationPlayer.play("Opening")
	
	if isHub:
		#Récupérer les infos enregistrées
		var level = int(id_next_lvl.split(".")[1]) #On récupère le num du niveau
		notes = PlayerDataSaver.WorldStats.compo[level]
		var n=""
		for i in notes:
			if i == true: 
				n+="1"
			else:
				n+="0"
		$Panel/Hub/NotesPlayer.play(n)
		canAccess = PlayerDataSaver.WorldStats.access[level]
		if !canAccess: $AnimationPlayer.play("Closed")
		else: $AnimationPlayer.play("Idle")
	else:
		$AnimationPlayer.play("Idle")
		canAccess=true
	
	$Panel/Label.text = texte
	z_index = get_parent().z_index
	collision_layer = 0
	collision_mask = 2**layer
	if sprite:
		$Sprite2D.texture = sprite
	else:
		if $Sprite2D.texture == null:
			print("⚠ Aucune texture assignée à l'objet !")

func _on_body_entered(body: Node2D) -> void:
	"""Affiche le texte d'interaction"""
	if canAccess==true:
		if body.name == "Player":
			$Panel.visible = true
			if !isHub: $Panel/Hub.hide()
			can_interact = true

func _on_body_exited(body: Node2D) -> void:
	"""Cache le texte d'interaction"""
	if canAccess == true:
		if body.name == "Player":
			$Panel.visible = false
			can_interact = false

func _input(event: InputEvent) -> void:
	"""Déclenche le changement de niveau"""
	if Input.is_action_just_pressed("interagir") and can_interact and canAccess:
		$AnimationPlayer.play("Opening")
		PlayerDataSaver.PlayerStats.last_lvl = PlayerDataSaver.PlayerStats.current_lvl
		PlayerDataSaver.PlayerStats.current_lvl = id_next_lvl
		if not isHub:PlayerDataSaver.WorldStats.level_completed(id_unlocked_lvl)
		Main.get_node("Globals Levels").change_lvl(id_next_lvl, titre, sous_titre)
