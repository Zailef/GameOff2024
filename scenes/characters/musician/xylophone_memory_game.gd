extends Node3D
class_name XylophoneMemoryGame

@onready var state_machine = $MemoryGameStateMachine
@onready var idle_state = $MemoryGameStateMachine/IdleState
@onready var show_sequence_state = $MemoryGameStateMachine/ShowSequenceState
@onready var player_input_state = $MemoryGameStateMachine/PlayerInputState
@onready var result_state = $MemoryGameStateMachine/ResultState
@onready var xylophone: Xylophone = $Xylophone
@onready var audio_streams: Node3D = $AudioStreams

var key_audio_stream_players = {}

var available_notes = ["C3", "D3", "E3", "F3", "G3", "A4", "B4", "C4"]
var sequence = []
var current_index = 0
var player_index = 0
var current_round = 1
@export var num_rounds = 2
@export var round_note_count = 3

func _ready():
	state_machine.owner_node = self
	state_machine.initial_state = idle_state
	state_machine._ready()

	for note in available_notes:
		key_audio_stream_players[note] = audio_streams.get_node(note + "KeyPlayer")

	xylophone.note_played.connect(player_input_state.handle_note)

func _process(delta):
	state_machine.update(delta)

func start_game():
	state_machine.change_state(show_sequence_state)

func play_note(note: String) -> void:
	print("Playing note: ", note)
	var original_material_callback = xylophone.get_surface_material_override_by_note(note)
	var audio_player = key_audio_stream_players[note]
	audio_player.play()
	await audio_player.finished
	original_material_callback.call()

func generate_sequence():
	sequence = []

	for i in range(round_note_count):
		var random_note := randi() % 8
		sequence.append(available_notes[random_note])
	
	return sequence

func log_diagnostics() -> void:
	print("Current round: ", current_round)
	print("Current index: ", current_index)
	print("Sequence: ", sequence)
	print("Round note count: ", round_note_count)
	print("Num rounds: ", num_rounds)
