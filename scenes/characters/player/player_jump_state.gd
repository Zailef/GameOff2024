extends BaseState
class_name PlayerJumpState

var player_node: Player

@export var jump_velocity: float = 4.5
@export var jump_grace_period: float = 0.1

var jump_timer: float = 0.0
var animation_player: AnimationPlayer

func _ready() -> void:
	state_name = "PLAYER_JUMP_STATE"

func enter() -> void:
	super.enter()
	if player_node.is_on_floor():
		player_node.velocity.y = jump_velocity
		jump_timer = jump_grace_period
		animation_player = player_node.player_model_animated.get_node("AnimationPlayer")
		animation_player.play("jump")

func exit() -> void:
	super.exit()
	if animation_player:
		animation_player.stop()

func update(delta: float) -> void:
	if player_node.velocity.y < 0:
		player_node.state_machine.change_state(player_node.player_fall_state)

	if jump_timer > 0.0:
		jump_timer -= delta

	if jump_timer <= 0.0 and player_node.is_on_floor():
		if player_node.velocity.length() > 0:
			player_node.state_machine.change_state(player_node.player_move_state)
		else:
			player_node.state_machine.change_state(player_node.player_idle_state)
		return

	var input_dir = Input.get_vector(
		ActionNames.TURN_LEFT,
		ActionNames.TURN_RIGHT,
		ActionNames.MOVE_FORWARDS,
		ActionNames.MOVE_BACKWARDS)

	if input_dir.length() > 0:
		player_node.state_machine.change_state(player_node.player_move_state)
	
	handle_turning(input_dir, delta)

	player_node.velocity += player_node.get_gravity() * delta
	player_node.move_and_slide()

func handle_turning(input_direction: Vector2, delta: float) -> void:
	# Allow turning whilst jumping
	if input_direction.x != 0:
		var rotation_amount = input_direction.x * player_node.player_rotation_speed * delta
		player_node.rotate_y(deg_to_rad(-rotation_amount))