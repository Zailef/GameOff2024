extends BaseState
class_name IdleState

var owner_node: XylophoneMemoryGame

func _ready() -> void:
    state_name = "MEMORY_GAME_IDLE_STATE"

func enter() -> void:
    super.enter()
    Input.mouse_mode = Input.MOUSE_MODE_HIDDEN

    owner_node.sequence = []
    owner_node.current_index = 0
    owner_node.player_index = 0
    owner_node.current_round = 1
