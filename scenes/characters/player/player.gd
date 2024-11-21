extends CharacterBody3D
class_name Player

@export var player_rotation_speed: float = 150.0

@onready var state_machine: PlayerStateMachine = $PlayerStateMachine
@onready var player_idle_state: PlayerIdleState = $PlayerStateMachine/PlayerIdleState
@onready var player_move_state: PlayerMoveState = $PlayerStateMachine/PlayerMoveState
@onready var player_jump_state: PlayerJumpState = $PlayerStateMachine/PlayerJumpState

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	state_machine.update(delta)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.handle_input(event)
