extends Node3D
class_name SpawnCard

@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var spawn_point: Marker3D = $SpawnPoint
@onready var card: CSGBox3D = $Card
@onready var spawn_activated_sound: AudioStreamPlayer = $SpawnActivatedSound

@export var is_active_spawn: bool = false

static var activation_count: int = 0

func _ready() -> void:
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)

func _on_player_detection_area_body_entered(body: Node) -> void:
	if not body is Player:
		return
	
	is_active_spawn = true
	card.material_overlay.set_shader_parameter("is_active", true)

	if activation_count > 0:
		spawn_activated_sound.play()
	
	for child in get_tree().get_nodes_in_group("spawn_cards"):
		if child != self:
			child.is_active_spawn = false
			child.card.material_overlay.set_shader_parameter("is_active", false)

	activation_count += 1
