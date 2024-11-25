extends BaseState
class_name IdleState

var owner_node: XylophoneMemoryGame

func _ready() -> void:
    state_name = "MEMORY_GAME_IDLE_STATE"

func enter() -> void:
    super.enter()
    Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
    owner_node.reset_game()
    SignalManager.player_unfreeze_requested.emit()
