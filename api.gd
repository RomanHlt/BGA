extends Node2D

var url = "https://webhook.site/5f225a7b-a7d8-4cdc-90cb-371c6ee01e5d"  # URL de l'API

@onready var http_request = $HTTPRequest

func _ready() -> void:
	http_request.request_completed.connect(_on_request_completed)

	var pseudo = "PlayerTest"
	var temps = 92.35
	var date = get_current_date()
	
	var score_data = {
		"pseudo": pseudo,
		"time": temps,
		"date": date
	}

	send_score(score_data)

func send_score(data: Dictionary) -> void:
	var json = JSON.stringify(data)
	var headers = ["Content-Type: application/json"]
	var error = http_request.request(url, headers, HTTPClient.METHOD_POST, json)
	if error != OK:
		print("Erreur d'envoi HTTP :", error)

func _on_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if response_code == 200:
		print("Score envoyé avec succès.")
	else:
		print("Erreur lors de l'envoi du score : code HTTP", response_code)

func get_current_date() -> String:
	var d = Time.get_datetime_dict_from_system() # Prend la date complète (avec jour de la semaine etcc flm)
	return "%04d-%02d-%02d" % [d.year, d.month, d.day]  # Format ISO : 2025-07-29 (mieux, je comprends pas le debut de la ligne mais ca marche)
