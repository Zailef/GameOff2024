extends Node3D
class_name MusicianStall

@onready var mini_game_camera: Camera3D = $XylophoneMemoryGame/MiniGameCamera
@onready var interaction_handler: InteractionHandler = $XylophoneMemoryGame/InteractionHandler
@onready var xylophone_memory_game: XylophoneMemoryGame = $XylophoneMemoryGame
@onready var audio_stream_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
@onready var original_audio_stream_player_volume_db: float = audio_stream_player.volume_db

@export var mini_game_volumne_reduction_db: float = -5

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	xylophone_memory_game.game_started.connect(_on_game_started)
	xylophone_memory_game.game_ended.connect(_on_game_ended)

func _on_interaction_started() -> void:
	print("Started talking to the musician")
	mini_game_camera.current = true
	xylophone_memory_game.start_game()

func _on_game_started() -> void:
	audio_stream_player.volume_db = mini_game_volumne_reduction_db

func _on_game_ended() -> void:
	audio_stream_player.volume_db = original_audio_stream_player_volume_db
