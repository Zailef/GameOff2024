extends Node3D
class_name Xylophone

signal note_played(note: String)

@onready var key_areas: Node3D = $KeyAreas
@onready var xylophone_mesh: MeshInstance3D = $Xyophone

var note_to_index_map = {
	"C3": 2,
	"D3": 3,
	"E3": 4,
	"F3": 5,
	"G3": 6,
	"A4": 7,
	"B4": 8,
	"C4": 9
}

func _ready():
	for note_area in key_areas.get_children():
		note_area = note_area as Area3D
		note_area.input_event.connect(_on_input_event.bind(note_area))

func _on_input_event(_camera, event, _event_position, _normal, _shape_idx, area):
	if event is InputEventMouseButton:
		if event.pressed:
			note_played.emit(area.get_groups()[0])

func get_surface_material_override_by_note(note: String) -> Callable:
	var note_index = note_to_index_map[note]
	var material = xylophone_mesh.get_active_material(note_index)
	var new_material = material.duplicate()
	new_material.albedo_color = Color(0.5, 0.5, 0.5)
	xylophone_mesh.set_surface_override_material(note_index, new_material)
	return func(): xylophone_mesh.set_surface_override_material(note_index, null)
