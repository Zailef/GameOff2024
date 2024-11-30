extends Node3D
class_name FortuneTellerStall

@onready var interaction_handler: InteractionHandler = $InteractionHandler

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)

func _on_interaction_started() -> void:
	print("Started talking to the fortune teller")
