extends Node3D
class_name FirePlatform

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var card: CSGBox3D = $Card

var is_player_on_platform: bool = false
var player: Player

func _ready() -> void:
	animation_player.play("enflame")

	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)

func _on_player_detection_area_body_entered(body: Node) -> void:
	if body is Player:
		player = body as Player
		is_player_on_platform = true
		SignalManager.player_entered_fire_area.emit()

func _on_player_detection_area_body_exited(body: Node) -> void:
	if body is Player:
		is_player_on_platform = false
		player = null
		SignalManager.player_exited_fire_area.emit()
