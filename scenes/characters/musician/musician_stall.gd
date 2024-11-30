extends Node3D
class_name MusicianStall

@onready var mini_game_camera: Camera3D = $XylophoneMemoryGame/MiniGameCamera
@onready var interaction_handler: InteractionHandler = $XylophoneMemoryGame/InteractionHandler
@onready var xylophone_memory_game: XylophoneMemoryGame = $XylophoneMemoryGame
@onready var level_music_player: AudioStreamPlayer3D = $LevelMusicPlayer
@onready var player_discovery_area: Area3D = $PlayerDiscoveryArea

@export var standard_volume_db: float = -2
@export var mini_game_volumne_reduction_db: float = -5

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	player_discovery_area.body_entered.connect(_on_player_discovery_area_body_entered)
	xylophone_memory_game.game_started.connect(_on_game_started)
	xylophone_memory_game.game_ended.connect(_on_game_ended)

func _on_interaction_started() -> void:
	mini_game_camera.current = true
	xylophone_memory_game.start_game()

func _on_game_started() -> void:
	level_music_player.volume_db = mini_game_volumne_reduction_db

func _on_game_ended() -> void:
	level_music_player.volume_db = standard_volume_db

func _on_player_discovery_area_body_entered(body: Node) -> void:
	if body is Player:
		level_music_player.attenuation_model = AudioStreamPlayer3D.AttenuationModel.ATTENUATION_DISABLED
		level_music_player.volume_db = standard_volume_db
		body.music_player_remote_transform.remote_path = level_music_player.get_path()
		player_discovery_area.queue_free()
