extends CharacterBody3D
class_name Player

@export var player_rotation_speed: float = 160.0

@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var player_idle_state: PlayerIdleState = $PlayerStateMachine/PlayerIdleState
@onready var player_move_state: PlayerMoveState = $PlayerStateMachine/PlayerMoveState
@onready var player_jump_state: PlayerJumpState = $PlayerStateMachine/PlayerJumpState
@onready var player_freeze_state: PlayerFreezeState = $PlayerStateMachine/PlayerFreezeState
@onready var third_person_camera: Camera3D = %ThirdPersonCamera

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	SignalManager.player_freeze_requested.connect(_on_player_freeze_requested)
	SignalManager.player_unfreeze_requested.connect(_on_player_unfreeze_requested)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)

func _on_player_freeze_requested() -> void:
	state_machine.change_state(player_freeze_state)

func _on_player_unfreeze_requested() -> void:
	third_person_camera.make_current()
	state_machine.change_state(player_idle_state)