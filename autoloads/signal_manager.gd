extends Node

signal player_freeze_requested
signal player_unfreeze_requested

func _ready():
    set_process(false)
    set_physics_process(false)
    set_process_unhandled_input(false)
