extends BaseState
class_name PlayerMoveState

var player_node: Player

@export var move_speed: float = 5.0
@export var sprint_modifier: float = 1.5

var is_sprinting: bool = false
var direction: Vector3 = Vector3.ZERO
var input_direction: Vector2 = Vector2.ZERO

var current_move_speed: float:
	get: return move_speed * (sprint_modifier if is_sprinting else 1.0)

func _ready() -> void:
	state_name = "PLAYER_MOVE_STATE"

func exit() -> void:
	super.exit()
	is_sprinting = false

func update(delta: float) -> void:
	input_direction = Input.get_vector(
		ActionNames.TURN_LEFT,
		ActionNames.TURN_RIGHT,
		ActionNames.MOVE_FORWARDS,
		ActionNames.MOVE_BACKWARDS)

	handle_state_transitions()
	handle_movement(delta)
	handle_gravity(delta)
	player_node.move_and_slide()

func handle_movement(delta: float) -> void:
	is_sprinting = Input.is_action_pressed(ActionNames.SPRINT)
	
	# Only consider forward/backward movement
	direction = (player_node.transform.basis * Vector3(0, 0, input_direction.y)).normalized()

	if direction:
		player_node.velocity.x = direction.x * current_move_speed
		player_node.velocity.z = direction.z * current_move_speed
	else:
		player_node.velocity.x = move_toward(player_node.velocity.x, 0, current_move_speed)
		player_node.velocity.z = move_toward(player_node.velocity.z, 0, current_move_speed)

	# Handle rotation based on left/right input
	if input_direction.x != 0:
		var rotation_amount = input_direction.x * player_node.player_rotation_speed * delta
		player_node.rotate_y(deg_to_rad(-rotation_amount))

func handle_gravity(delta: float) -> void:
	if not player_node.is_on_floor():
		player_node.velocity += player_node.get_gravity() * delta

func handle_state_transitions() -> void:
	if player_node.is_on_floor():
		if player_node.velocity.length() == 0 and input_direction.length() == 0:
			player_node.state_machine.change_state(player_node.player_idle_state)
		elif Input.is_action_just_pressed(ActionNames.JUMP):
			player_node.state_machine.change_state(player_node.player_jump_state)