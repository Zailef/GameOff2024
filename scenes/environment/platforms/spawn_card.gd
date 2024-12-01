extends Node3D
class_name SpawnCard

@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var spawn_point: Marker3D = $SpawnPoint
@onready var activation_light: OmniLight3D = $ActivationLight

@export var is_active_spawn: bool = false

func _ready() -> void:
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)

func _on_player_detection_area_body_entered(body: Node) -> void:
	if body is Player:
		is_active_spawn = true
		activation_light.show()
		
		for child in get_tree().get_nodes_in_group("spawn_cards"):
			if child != self:
				child.is_active_spawn = false
				child.activation_light.hide()
