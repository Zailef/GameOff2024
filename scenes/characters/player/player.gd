extends CharacterBody3D

@export var move_speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.001
@export var camera_rotation_speed: float = 15.0
@export var player_rotation_speed: float = 100.0
@export var min_camera_yaw: float = -45
@export var max_camera_yaw: float = 45

@onready var twist_pivot: Node3D = $TwistPivot
@onready var pitch_pivot: Node3D = $TwistPivot/PitchPivot

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	var input_dir := Input.get_vector(ActionNames.TURN_LEFT, ActionNames.TURN_RIGHT, ActionNames.MOVE_FORWARDS, ActionNames.MOVE_BACKWARDS)

	handle_movement(input_dir, delta)
	handle_camera_rotation(input_dir, delta)
	move_and_slide()

func handle_movement(input_direction: Vector2, delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed(ActionNames.JUMP) and is_on_floor():
		velocity.y = jump_velocity

	var direction := (transform.basis * Vector3(0, 0, input_direction.y)).normalized() # Only consider forward/backward movement

	if direction:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, move_speed)
		velocity.z = move_toward(velocity.z, 0, move_speed)

	# Handle rotation based on left/right input
	if input_direction.x != 0:
		var rotation_amount = input_direction.x * player_rotation_speed * delta
		rotate_y(deg_to_rad(-rotation_amount))

func handle_camera_rotation(input_direction: Vector2, delta: float) -> void:
	var mouse_motion = Input.get_last_mouse_velocity()
	
	# Calculate the target rotations
	var target_yaw = twist_pivot.rotation.y + deg_to_rad(-mouse_motion.x * mouse_sensitivity)
	var target_pitch = pitch_pivot.rotation.x + deg_to_rad(-mouse_motion.y * mouse_sensitivity) # Invert the y-axis
	
	# Check if the player is moving
	var is_moving = input_direction.length() > 0
	
	# Clamp the yaw if the player is moving
	if is_moving:
		target_yaw = clamp(target_yaw, deg_to_rad(min_camera_yaw), deg_to_rad(max_camera_yaw))
	
	# Interpolate towards the target rotations
	twist_pivot.rotation.y = lerp(twist_pivot.rotation.y, target_yaw, camera_rotation_speed * delta)
	
	# Clamp the pitch and interpolate
	target_pitch = clamp(target_pitch, deg_to_rad(-45), deg_to_rad(45))
	pitch_pivot.rotation.x = lerp(pitch_pivot.rotation.x, target_pitch, camera_rotation_speed * delta)
