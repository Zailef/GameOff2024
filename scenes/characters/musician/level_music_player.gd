extends AudioStreamPlayer3D

@export var tracks: Array[AudioStream] = []

var current_track_index := 0

func _ready() -> void:
	play()
	finished.connect(_on_track_finished)

func _on_track_finished() -> void:
	current_track_index = (current_track_index + 1) % tracks.size()
	stream = tracks[current_track_index]
	play()
