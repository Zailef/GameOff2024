extends AudioStreamPlayer

signal menu_music_requested
signal menu_music_stop_requested

func _ready() -> void:
	menu_music_requested.connect(_on_menu_music_requested)
	menu_music_stop_requested.connect(stop)
	finished.connect(play)

func _on_menu_music_requested() -> void:
	if not playing:
		play()
