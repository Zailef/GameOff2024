extends Node3D
class_name Xylophone

signal note_played(note: String)

@onready var key_areas: Node3D = $KeyAreas
@onready var xylophone_mesh: MeshInstance3D = $Xyophone
@onready var xylophone_mallet: Node3D = $XylophoneMallet
@onready var xylophone_path: Path3D = $XylophonePath
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_streams: Node3D = $AudioStreams

@export var player_default_delay := .3

var current_player_note: String
var key_audio_stream_players := {}

var note_data_map = {
	"C3": {"path_index": 0, "material_index": 2},
	"D3": {"path_index": 1, "material_index": 3},
	"E3": {"path_index": 2, "material_index": 4},
	"F3": {"path_index": 3, "material_index": 5},
	"G3": {"path_index": 4, "material_index": 6},
	"A4": {"path_index": 5, "material_index": 7},
	"B4": {"path_index": 6, "material_index": 8},
	"C4": {"path_index": 7, "material_index": 9}
}

func _ready():
	for note_area in key_areas.get_children():
		note_area = note_area as Area3D
		note_area.input_event.connect(_on_input_event.bind(note_area))

	for note in note_data_map.keys():
		key_audio_stream_players[note] = audio_streams.get_node(note + "KeyPlayer")

func _on_input_event(_camera, event, _event_position, _normal, _shape_idx, area):
	var note = area.get_groups()[0]

	if event is InputEventMouseMotion:
		var key_index = note_data_map[note]["path_index"]
		var new_position = xylophone_path.curve.get_point_position(key_index)
		xylophone_mallet.transform.origin = Vector3(new_position.x, xylophone_mallet.transform.origin.y, new_position.z + .4)

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			note_played.emit(note)

func play_note(note: String, is_player_note: bool = false) -> void:
	print("Playing note: ", note)
	var original_material_callback = _override_surface_material(note)
	var audio_player = key_audio_stream_players[note]

	if not is_player_note:
		audio_player.play()
		await audio_player.finished
	else:
		current_player_note = note
		animation_player.play("hit_key")
		await (get_tree().create_timer(player_default_delay).timeout)

	original_material_callback.call()

func play_player_note() -> void:
	var audio_player = key_audio_stream_players[current_player_note]
	audio_player.play()

func _override_surface_material(note: String) -> Callable:
	var note_index = note_data_map[note]["material_index"]
	var material = xylophone_mesh.get_active_material(note_index)
	var new_material: BaseMaterial3D = material.duplicate()
	new_material.emission_enabled = true
	new_material.emission = new_material.albedo_color
	new_material.emission_energy = 2
	xylophone_mesh.set_surface_override_material(note_index, new_material)
	return func(): xylophone_mesh.set_surface_override_material(note_index, null)
