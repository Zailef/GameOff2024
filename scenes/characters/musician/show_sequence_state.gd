extends BaseState
class_name ShowSequenceState

var owner_node: XylophoneMemoryGame

func _ready() -> void:
	state_name = "MEMORY_GAME_SHOW_SEQUENCE_STATE"

func enter():
	super.enter()
	SignalManager.player_freeze_requested.emit()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	owner_node.generate_sequence()
	owner_node.current_index = 0
	play_next_note()

func play_next_note():
	if owner_node.current_index < owner_node.sequence.size():
		await (get_tree().create_timer(1.0).timeout)
		owner_node.xylophone.play_note(owner_node.sequence[owner_node.current_index])
		owner_node.current_index += 1
		play_next_note()
	else:
		get_parent().change_state(owner_node.player_input_state)
