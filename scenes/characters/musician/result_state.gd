extends BaseState
class_name ResultState

const ANIMATION_BOW: String = "bow"
const ANIMATION_GAME_FAILED: String = "game_failed"

var owner_node: XylophoneMemoryGame
var musician_animation_player: AnimationPlayer

func _ready() -> void:
	state_name = "MEMORY_GAME_RESULT_STATE"

func exit() -> void:
	super.exit()
	await musician_animation_player.animation_finished

func enter() -> void:
	super.enter()
	
	musician_animation_player = owner_node.musician_character.get_node("AnimationPlayer")

	if owner_node.player_index >= owner_node.sequence.size():
		if owner_node.current_round < owner_node.num_rounds + 1:
			owner_node.success_audio_player.play()
			musician_animation_player.play(ANIMATION_BOW)
			await musician_animation_player.animation_finished
			progress_round()
		else:
			owner_node.current_round = 1
			musician_animation_player.play(ANIMATION_BOW)
			get_parent().change_state(owner_node.idle_state)
			owner_node.game_ended.emit(true)
	else:
		owner_node.failure_audio_player.play()
		musician_animation_player.play(ANIMATION_GAME_FAILED)
		owner_node.current_round = 1
		get_parent().change_state(owner_node.idle_state)
		owner_node.game_ended.emit(false)

func progress_round() -> void:
	owner_node.current_round += 1
	owner_node.round_note_count += 1
	await (get_tree().create_timer(1.0).timeout)
	get_parent().change_state(owner_node.show_sequence_state)
