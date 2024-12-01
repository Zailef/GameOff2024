extends Node3D

func _ready() -> void:
	MenuMusicPlayer.menu_music_stop_requested.emit()
