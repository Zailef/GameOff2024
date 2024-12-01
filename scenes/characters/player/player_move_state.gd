extends BaseState
class_name PlayerMoveState

const SLIPPING_ANIMATION: String = "Slipping"
const TURNING_ANIMATION: String = "turning"
const RUN_ANIMATION: String = "run"

var player_node: Player
var animation_player: AnimationPlayer

@export var move_speed: float = 5.0
@export var backward_modifier: float = 0.5
@export var sprint_modifier: float = 1.25
@export var slip_modifier: float = 1.8

var is_sprinting: bool = false
var is_slipping: bool = false
var is_moving_backward: bool = false
var is_spot_turning: bool = false

var direction: Vector3 = Vector3.ZERO
var input_direction: Vector2 = Vector2.ZERO

var current_move_speed: float:
	get:
		if is_moving_backward:
			return move_speed * backward_modifier
		elif is_slipping:
			return move_speed * slip_modifier
		else:
			return move_speed * (sprint_modifier if is_sprinting else 1.0)

func _ready() -> void:
	state_name = "PLAYER_MOVE_STATE"

	SignalManager.player_entered_slippery_area.connect(func(): is_slipping = true)
	SignalManager.player_exited_slippery_area.connect(func(): is_slipping = false)

func enter() -> void:
	super.enter()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animation_player = player_node.player_model_animated.get_node("AnimationPlayer")

func exit() -> void:
	super.exit()
	is_sprinting = false
	animation_player.stop()

func update(delta: float) -> void:
	input_direction = Input.get_vector(
		ActionNames.TURN_LEFT,
		ActionNames.TURN_RIGHT,
		ActionNames.MOVE_FORWARDS,
		ActionNames.MOVE_BACKWARDS)

	handle_movement(delta)
	handle_animations()
	player_node.move_and_slide()
	handle_state_transitions()

func handle_movement(delta: float) -> void:
	# Only consider forward/backward movement
	direction = (player_node.transform.basis * Vector3(0, 0, input_direction.y)).normalized()

	is_sprinting = Input.is_action_pressed(ActionNames.SPRINT)
	is_moving_backward = Input.is_action_pressed(ActionNames.MOVE_BACKWARDS)
	is_spot_turning = false

	if is_slipping:
		player_node.velocity.x = lerp(player_node.velocity.x, direction.x * current_move_speed, 0.02)
		player_node.velocity.z = lerp(player_node.velocity.z, direction.z * current_move_speed, 0.02)
	else:
		if direction.length() > 0:
			player_node.velocity.x = direction.x * current_move_speed
			player_node.velocity.z = direction.z * current_move_speed
		else:
			player_node.velocity.x = move_toward(player_node.velocity.x, 0, current_move_speed)
			player_node.velocity.z = move_toward(player_node.velocity.z, 0, current_move_speed)

	# Handle rotation based on left/right input
	if input_direction.x != 0:
		is_spot_turning = not is_slipping and player_node.velocity.length() == 0
		var rotation_amount = input_direction.x * player_node.player_rotation_speed * delta
		player_node.rotate_y(deg_to_rad(-rotation_amount))

func handle_animations() -> void:
	if is_spot_turning and animation_player.current_animation != TURNING_ANIMATION:
		animation_player.play(TURNING_ANIMATION)
	elif is_slipping and animation_player.current_animation != SLIPPING_ANIMATION:
		animation_player.play(SLIPPING_ANIMATION)
	elif not is_spot_turning and not is_slipping and animation_player.current_animation != RUN_ANIMATION:
		animation_player.play(RUN_ANIMATION)

func handle_state_transitions() -> void:
	if player_node.is_on_floor():
		if player_node.velocity.length() == 0 and input_direction.length() == 0:
			player_node.state_machine.change_state(player_node.player_idle_state)
		elif Input.is_action_just_pressed(ActionNames.JUMP):
			player_node.state_machine.change_state(player_node.player_jump_state)
	else:
		player_node.state_machine.change_state(player_node.player_fall_state)
