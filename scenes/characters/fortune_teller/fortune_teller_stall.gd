extends Node3D
class_name FortuneTellerStall

const ANIMATION_INTERACT_TRANSITION: String = "interact_transition"
const ANIMATION_TALKING: String = "talking"
const ANIMATION_IDLE: String = "idle"

var audio_streams: Array[AudioStream] = [
	preload("res://audio/characters/fortune_teller/monologue.mp3"),
	preload("res://audio/characters/fortune_teller/see_me_again.mp3"),
	preload("res://audio/characters/fortune_teller/finale.mp3"),
]

var player: Player

var conversation_state = 0

@onready var interaction_handler: InteractionHandler = $InteractionHandler
@onready var animation_player: AnimationPlayer = $FortuneTellerCharacter/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	animation_player.play(ANIMATION_IDLE)
	SignalManager.all_major_arcana_cards_added_to_inventory.connect(func(): conversation_state = 2)

func _on_interaction_started() -> void:
	animation_player.play(ANIMATION_INTERACT_TRANSITION)
	await animation_player.animation_finished
	animation_player.play(ANIMATION_TALKING)
	audio_stream_player.stream = audio_streams[conversation_state % audio_streams.size()]
	audio_stream_player.play()
	await audio_stream_player.finished

	if conversation_state == 0:
		conversation_state += 1
