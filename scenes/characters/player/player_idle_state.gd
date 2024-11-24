extends BaseState
class_name PlayerIdleState

var player_node: Player

func _ready() -> void:
	state_name = "PLAYER_IDLE_STATE"

func enter() -> void:
	super.enter()
	player_node.set_process(true)
	player_node.set_physics_process(true)
	player_node.set_process_unhandled_input(true)

func update(_delta: float) -> void:
	var input_direction = Input.get_vector(
		ActionNames.TURN_LEFT,
		ActionNames.TURN_RIGHT,
		ActionNames.MOVE_FORWARDS,
		ActionNames.MOVE_BACKWARDS)

	if Input.is_action_just_pressed(ActionNames.JUMP):
		player_node.state_machine.change_state(player_node.player_jump_state)
	elif input_direction.length() > 0:
		player_node.state_machine.change_state(player_node.player_move_state)
