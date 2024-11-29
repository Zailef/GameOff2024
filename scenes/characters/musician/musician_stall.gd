extends Node3D
class_name MusicianStall

@onready var mini_game_camera: Camera3D = $XylophoneMemoryGame/MiniGameCamera
@onready var interaction_handler: InteractionHandler = $XylophoneMemoryGame/InteractionHandler
@onready var xylophone_memory_game: XylophoneMemoryGame = $XylophoneMemoryGame

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)

func _on_interaction_started() -> void:
	print("Started talking to the musician")
	mini_game_camera.current = true
	xylophone_memory_game.start_game()
