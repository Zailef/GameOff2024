extends CSGBox3D
class_name FadePlatform

@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fade_timer: Timer = $FadeTimer

var is_platform_revealed: bool = false
var is_player_on_platform: bool = false

func _ready() -> void:
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)
	fade_timer.timeout.connect(_on_fade_timer_timeout)

func _on_player_detection_area_body_entered(body: Node) -> void:
	if body is Player:
		is_player_on_platform = true

		if not is_platform_revealed:
			is_platform_revealed = true
			animation_player.play("fade_in")
			await animation_player.animation_finished
			material.distance_fade_mode = material.DISTANCE_FADE_DISABLED
			material.transparency = material.TRANSPARENCY_DISABLED

func _on_player_detection_area_body_exited(body: Node) -> void:
	if body is Player and is_platform_revealed:
		is_player_on_platform = false
		fade_timer.start()

func _on_fade_timer_timeout() -> void:
	if not is_platform_revealed or is_player_on_platform:
		return

	is_platform_revealed = false
	material.transparency = material.TRANSPARENCY_ALPHA
	animation_player.play("fade_out")
	await animation_player.animation_finished
