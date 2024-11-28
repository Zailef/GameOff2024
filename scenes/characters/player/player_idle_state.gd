extends BaseState
class_name PlayerIdleState

var player_node: Player
var animation_player: AnimationPlayer

func _ready() -> void:
	state_name = "PLAYER_IDLE_STATE"

func enter() -> void:
	super.enter()
	player_node.set_process(true)
	player_node.set_physics_process(true)
	player_node.set_process_unhandled_input(true)

	if player_node.player_model_animated:
		animation_player = player_node.player_model_animated.get_node("AnimationPlayer")
		animation_player.play("rest")

func exit() -> void:
	super.exit()
	if animation_player:
		animation_player.stop()

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
