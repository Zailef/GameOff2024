extends BaseState
class_name ShowSequenceState

const ANIMATION_CONDUCT_TRANSITION: String = "conduct_transition"
const ANIMATION_CONDUCT: String = "conduct"

@export var start_delay: float = 1.0

var owner_node: XylophoneMemoryGame
var musician_animation_player: AnimationPlayer
var cancellation_requested: bool = false

func _ready() -> void:
	state_name = "MEMORY_GAME_SHOW_SEQUENCE_STATE"

func enter():
	super.enter()
	SignalManager.player_freeze_requested.emit()
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	owner_node.generate_sequence()
	owner_node.current_index = 0
	musician_animation_player = owner_node.musician_character.get_node("AnimationPlayer")
	musician_animation_player.play(ANIMATION_CONDUCT_TRANSITION)
	await musician_animation_player.animation_finished
	musician_animation_player.play(ANIMATION_CONDUCT)
	play_next_note()

func exit():
	cancellation_requested = false
	musician_animation_player.stop()

func update(_delta) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		cancellation_requested = true

func play_next_note():
	if cancellation_requested:
		get_parent().change_state(owner_node.idle_state)
		owner_node.game_ended.emit(false)
		return

	if owner_node.current_index < owner_node.sequence.size():
		await owner_node.xylophone.play_note(owner_node.sequence[owner_node.current_index])
		owner_node.current_index += 1
		play_next_note()
	else:
		get_parent().change_state(owner_node.player_input_state)
