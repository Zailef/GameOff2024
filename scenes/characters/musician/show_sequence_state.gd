extends BaseState
class_name ShowSequenceState

@export var start_delay: float = 1.0

var owner_node: XylophoneMemoryGame
var cancellation_requested: bool = false

func _ready() -> void:
	state_name = "MEMORY_GAME_SHOW_SEQUENCE_STATE"

func enter():
	super.enter()
	SignalManager.player_freeze_requested.emit()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	owner_node.generate_sequence()
	owner_node.current_index = 0
	await (get_tree().create_timer(start_delay).timeout)
	play_next_note()

func exit():
	cancellation_requested = false

func update(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		cancellation_requested = true

func play_next_note():
	if cancellation_requested:
		get_parent().change_state(owner_node.idle_state)
		return

	if owner_node.current_index < owner_node.sequence.size():
		await owner_node.xylophone.play_note(owner_node.sequence[owner_node.current_index])
		owner_node.current_index += 1
		play_next_note()
	else:
		get_parent().change_state(owner_node.player_input_state)
