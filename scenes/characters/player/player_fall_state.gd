extends BaseState
class_name PlayerFallState

const FALLING_ANIMATION: String = "falling"

var player_node: Player
var animation_player: AnimationPlayer

func _ready() -> void:
	state_name = "PLAYER_FALL_STATE"

func enter() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	super.enter()
	animation_player = player_node.player_model_animated.get_node("AnimationPlayer")
	animation_player.play(FALLING_ANIMATION)

func exit() -> void:
	super.exit()
	animation_player.stop()

func update(delta: float) -> void:
	handle_gravity(delta)
	handle_turning(Input.get_vector(
		ActionNames.TURN_LEFT,
		ActionNames.TURN_RIGHT,
		ActionNames.MOVE_FORWARDS,
		ActionNames.MOVE_BACKWARDS), delta)
		
	player_node.move_and_slide()

func handle_gravity(delta: float) -> void:
	if not player_node.is_on_floor():
		player_node.velocity += player_node.get_gravity() * delta
	else:
		player_node.state_machine.change_state(player_node.player_idle_state)

func handle_turning(input_direction: Vector2, delta: float) -> void:
	# Allow turning whilst jumping
	if input_direction.x != 0:
		var rotation_amount = input_direction.x * player_node.player_rotation_speed * delta
		player_node.rotate_y(deg_to_rad(-rotation_amount))