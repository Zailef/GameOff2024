extends Node3D
class_name MushroomCircle

@onready var mushroom_watch_area: Area3D = $MushroomWatchArea
@onready var mushrooms: Node3D = $Mushrooms
@onready var audio_players: Node3D = $AudioPlayers

func _ready() -> void:
	mushroom_watch_area.body_entered.connect(_on_mushroom_watch_area_body_entered)
	mushroom_watch_area.body_exited.connect(_on_mushroom_watch_area_body_exited)

	for audio_player in audio_players.get_children():
		audio_player = audio_player as AudioStreamPlayer3D
		audio_player.play()

	set_process(false)
	set_physics_process(false)

func _on_mushroom_watch_area_body_entered(body: Node) -> void:
	if body is Player:
		for mushroom in mushrooms.get_children():
			mushroom.start_tracking_player()

func _on_mushroom_watch_area_body_exited(body: Node) -> void:
	if body is Player:
		for mushroom in mushrooms.get_children():
			mushroom.stop_tracking_player()
