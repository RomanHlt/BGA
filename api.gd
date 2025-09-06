extends Control

var url = "https://bga.insash.org/api/send/scores/"
var send = false

@onready var http_request = $HTTPRequest

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)
	http_request.request(url, [], HTTPClient.METHOD_GET)
	
	if Main.get_node("CanvasLayer/Menus/MenuSettings").speedRun:
		self.visible = true
		await get_tree().create_timer(2).timeout
		$Label.text = "Vous avez fini le jeu en : " + String.num(Main.get_node("CanvasLayer/Clock").timer, 3) + " secondes.\nPour envoyer ce score entrez un pseudo."
	else:
		self.visible = false

func _process(delta: float) -> void:
	if len($LineEdit.text) > 2 and not send:
		$Envoyer.disabled = false
	else:
		$Envoyer.disabled = true

func _on_envoyer_pressed() -> void:
	var pseudo = $LineEdit.text
	var temps = Main.get_node("CanvasLayer/Clock").timer
	var score_data = {
	"pseudo": pseudo,
	"time": temps,
	"token" : "letoken"
	}
	send_score(score_data)
	send = true
	$Envoyer.text = "OK"
	$LineEdit.editable = false

func send_score(data: Dictionary) -> void:
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		print("Erreur d'envoi HTTP :", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		var json = JSON.parse_string(body.get_string_from_utf8())
		if typeof(json) == TYPE_ARRAY:
			Main.get_node("Globals Stats").scores = json
			print("Données récupérées :")
			for score in json:
				print("Nom :", score["name"], " | Temps :", score["time"])
		else:
			print("Format inattendu :", json)
	else:
		print("Erreur HTTP :", response_code)
