extends Node

signal player_freeze_requested
signal player_unfreeze_requested

signal player_entered_slippery_area
signal player_exited_slippery_area

signal player_entered_fire_area
signal player_exited_fire_area

func _ready():
    set_process(false)
    set_physics_process(false)
    set_process_unhandled_input(false)
