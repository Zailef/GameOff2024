extends Node
class_name MemoryGameStateMachine

@export var owner_node: XylophoneMemoryGame
@export var initial_state: BaseState

var current_state: BaseState

func _ready() -> void:
	for state in get_children():
		if state is BaseState:
			state.owner_node = owner_node
			state.exit()

	change_state(initial_state)

func change_state(new_state: BaseState) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

func update(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func handle_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)
