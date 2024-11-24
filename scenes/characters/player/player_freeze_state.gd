extends BaseState
class_name PlayerFreezeState

var player_node: Player

func _ready() -> void:
	state_name = "PLAYER_FREEZE_STATE"

func enter() -> void:
	super.enter()
	player_node.set_process(false)
	player_node.set_physics_process(false)
	player_node.set_process_unhandled_input(false)
