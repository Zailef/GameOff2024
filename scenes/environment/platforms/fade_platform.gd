extends CSGBox3D
class_name FadePlatform

@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var is_platform_revealed: bool = false

func _ready() -> void:
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)

func _on_player_detection_area_body_entered(body: Node) -> void:
	if body is Player:
		if not is_platform_revealed:
			is_platform_revealed = true
			animation_player.play("fade_in")
			await animation_player.animation_finished
			material.distance_fade_mode = material.DISTANCE_FADE_DISABLED
			material.transparency = material.TRANSPARENCY_DISABLED
			player_detection_area.monitoring = false
