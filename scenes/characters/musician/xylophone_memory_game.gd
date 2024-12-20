extends Node3D
class_name XylophoneMemoryGame

signal game_started
signal game_ended(is_win: bool)
signal round_won(stage: int)

@onready var state_machine = $MemoryGameStateMachine
@onready var idle_state = $MemoryGameStateMachine/IdleState
@onready var show_sequence_state = $MemoryGameStateMachine/ShowSequenceState
@onready var player_input_state = $MemoryGameStateMachine/PlayerInputState
@onready var result_state = $MemoryGameStateMachine/ResultState
@onready var xylophone: Xylophone = $Xylophone
@onready var success_audio_player: AudioStreamPlayer = $SuccessSound
@onready var failure_audio_player: AudioStreamPlayer = $FailureSound

@export var num_rounds := 2
@export var round_note_count := 3
@export var musician_character: Node3D

var available_notes = ["C3", "D3", "E3", "F3", "G3", "A4", "B4", "C4"]
var sequence := []
var current_index := 0
var player_index := 0
var current_round := 1

func _ready() -> void:
	state_machine.owner_node = self
	state_machine.initial_state = idle_state
	state_machine._ready()

	xylophone.note_played.connect(player_input_state.handle_note)

func _process(delta) -> void:
	state_machine.update(delta)

func start_game() -> void:
	state_machine.change_state(show_sequence_state)
	game_started.emit()

func generate_sequence() -> Array:
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

func reset_game() -> void:
	current_round = 1
	round_note_count = 3
	sequence = []
	current_index = 0
	player_index = 0
