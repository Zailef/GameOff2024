extends Node3D
class_name MusicianStall

@onready var mini_game_camera: Camera3D = $XylophoneMemoryGame/MiniGameCamera
@onready var interaction_handler: InteractionHandler = $XylophoneMemoryGame/InteractionHandler
@onready var xylophone_memory_game: XylophoneMemoryGame = $XylophoneMemoryGame
@onready var level_music_player: AudioStreamPlayer3D = $LevelMusicPlayer
@onready var player_discovery_area: Area3D = $PlayerDiscoveryArea
@onready var prize_one_win_location: Marker3D = $PrizeOneWinLocation
@onready var prize_two_win_location: Marker3D = $PrizeTwoWinLocation
@onready var prize_three_win_location: Marker3D = $PrizeThreeWinLocation

@export var standard_volume_db: float = -2
@export var mini_game_volumne_reduction_db: float = -5
@export var prize_one: Node3D
@export var prize_two: Node3D
@export var prize_three: Node3D

var stage_win_states = {
	1: false,
	2: false,
	3: false
}

var is_game_won: bool = false

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	player_discovery_area.body_entered.connect(_on_player_discovery_area_body_entered)
	xylophone_memory_game.game_started.connect(_on_game_started)
	xylophone_memory_game.game_ended.connect(_on_game_ended)
	xylophone_memory_game.round_won.connect(_on_round_won)

func _on_interaction_started() -> void:
	mini_game_camera.current = true
	xylophone_memory_game.start_game()

func _on_game_started() -> void:
	level_music_player.volume_db = mini_game_volumne_reduction_db

func _on_game_ended(is_win: bool) -> void:
	level_music_player.volume_db = standard_volume_db

	if is_win:
		is_game_won = true
		interaction_handler.queue_free()
	else:
		is_game_won = false
		interaction_handler.interaction_label.visible = true

func _on_player_discovery_area_body_entered(body: Node) -> void:
	if body is Player:
		level_music_player.attenuation_model = AudioStreamPlayer3D.AttenuationModel.ATTENUATION_DISABLED
		level_music_player.volume_db = standard_volume_db
		body.music_player_remote_transform.remote_path = level_music_player.get_path()
		player_discovery_area.queue_free()

func _on_round_won(stage: int) -> void:
	match stage:
		1:
			prize_one.global_transform.origin = prize_one_win_location.global_transform.origin
		2:
			prize_two.global_transform.origin = prize_two_win_location.global_transform.origin
		3:
			prize_three.global_transform.origin = prize_three_win_location.global_transform.origin
		_:
			pass
		
	stage_win_states[stage] = true
