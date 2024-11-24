extends BaseState
class_name ResultState

var owner_node: XylophoneMemoryGame

func _ready() -> void:
    state_name = "MEMORY_GAME_RESULT_STATE"

func enter() -> void:
    super.enter()
    if owner_node.player_index >= owner_node.sequence.size():
        if owner_node.current_round < owner_node.num_rounds + 1:
            owner_node.success_audio_player.play()
            await owner_node.success_audio_player.finished
            progress_round()
        else:
            owner_node.current_round = 1
            get_parent().change_state(owner_node.idle_state)
            print("Player won!")
    else:
        print("Player failed!")
        owner_node.failure_audio_player.play()
        owner_node.current_round = 1
        get_parent().change_state(owner_node.idle_state)

func progress_round() -> void:
    owner_node.current_round += 1
    owner_node.round_note_count += 1
    await (get_tree().create_timer(1.0).timeout)
    get_parent().change_state(owner_node.show_sequence_state)
