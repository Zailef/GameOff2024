extends Node

const MOVE_FORWARDS = "move_forwards"
const MOVE_BACKWARDS = "move_backwards"
const TURN_LEFT = "turn_left"
const TURN_RIGHT = "turn_right"
const JUMP = "jump"
const INTERACT = "interact"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
