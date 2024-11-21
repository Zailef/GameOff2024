extends Node
class_name BaseState

var state_name: String = "Base State"

func enter() -> void:
	print(state_name + " Entered")
	set_process(true)
	set_physics_process(true)
	set_process_unhandled_input(true)

func exit() -> void:
	print(state_name + " Exited")
	set_process(false)
	set_physics_process(false)
	set_process_unhandled_input(false)

func handle_input(_event: InputEvent) -> void:
	pass

func update(_delta: float) -> void:
	pass
