extends Node2D

@export_category("Dialogue")
@export var dialogueResource : DialogueResource
@export var dialogueName : String
@export_category("Trigger")
@export var oneTimeTrigger := true
@export var detectionLeftUntilTrigger := 1
@export_category("Technique")
@export var allLayer := true
@export var layer := 0

func _ready() -> void:
	if not allLayer:
		$Area2D.collision_mask = 2**layer

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		detectionLeftUntilTrigger -= 1
		print(detectionLeftUntilTrigger)
		if detectionLeftUntilTrigger < 1: # Activer le dialogue
			DialogueManager.show_dialogue_balloon(dialogueResource, dialogueName)
			if oneTimeTrigger: # Détruire la zone et ne plus jamais activer le dialogue
				self.queue_free()
