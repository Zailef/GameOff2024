extends Node

const MOVE_FORWARDS = "move_forwards"
const MOVE_BACKWARDS = "move_backwards"
const TURN_LEFT = "turn_left"
const TURN_RIGHT = "turn_right"
const JUMP = "jump"
const SPRINT = "sprint"
const INTERACT = "interact"
const CAMERA_ZOOM_IN = "camera_zoom_in"
const CAMERA_ZOOM_OUT = "camera_zoom_out"
const KILL_PLAYER = "kill_player"

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
