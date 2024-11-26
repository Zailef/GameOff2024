extends BaseState
class_name PlayerInputState

var owner_node: XylophoneMemoryGame
var is_handling_note: bool = false
var note_queue := []

func _ready() -> void:
	state_name = "MEMORY_GAME_PLAYER_INPUT_STATE"

func enter() -> void:
	super.enter()
	owner_node.player_index = 0
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
	owner_node.xylophone.xylophone_mallet.visible = true

func exit() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	owner_node.xylophone.xylophone_mallet.visible = false
	is_handling_note = false
	note_queue.clear()

func update(_delta) -> void:
	if note_queue.size() > 0 and not is_handling_note:
		print("Handling queued note", note_queue[0])
		handle_note(note_queue.pop_front())

func handle_note(note_pressed: String) -> void:
	if is_handling_note:
		note_queue.append(note_pressed)
		return

	owner_node.log_diagnostics()
	is_handling_note = true

	var is_correct_note: bool = note_pressed == owner_node.sequence[owner_node.player_index]

	await owner_node.xylophone.play_note(note_pressed, false)

	is_handling_note = false

	if is_correct_note:
		owner_node.player_index += 1
		if owner_node.player_index >= owner_node.sequence.size():
			get_parent().change_state(owner_node.result_state)
	else:
		get_parent().change_state(owner_node.result_state)
