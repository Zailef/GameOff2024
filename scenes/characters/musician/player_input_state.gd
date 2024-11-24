extends BaseState
class_name PlayerInputState

var owner_node: XylophoneMemoryGame

func _ready() -> void:
	state_name = "MEMORY_GAME_PLAYER_INPUT_STATE"

func enter() -> void:
	super.enter()
	owner_node.player_index = 0
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func handle_note(note_pressed: String) -> void:
	owner_node.log_diagnostics()

	var is_correct_note: bool = note_pressed == owner_node.sequence[owner_node.player_index]

	await owner_node.play_note(note_pressed)

	if is_correct_note:
		owner_node.player_index += 1
		if owner_node.player_index >= owner_node.sequence.size():
			get_parent().change_state(owner_node.result_state)
	else:
		get_parent().change_state(owner_node.result_state)
