extends Node3D
class_name DropPlatform

@onready var player_detection_area: Area3D = $PlayerDetectionArea
@onready var drop_timer: Timer = $DropTimer
@onready var drop_reset_timer: Timer = $DropResetTimer
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var original_position: Vector3 = global_transform.origin
@onready var card: CSGBox3D = $Card

@export var reset_time: float = 3.0
@export var drop_time: float = 1.0

var is_player_on_platform: bool = false
var original_animation_speed_scale: float = 1.0
var is_dropping: bool = false
var player: Player

func _ready() -> void:
	player_detection_area.body_entered.connect(_on_player_detection_area_body_entered)
	player_detection_area.body_exited.connect(_on_player_detection_area_body_exited)
	drop_timer.timeout.connect(_on_drop_timer_timeout)
	drop_reset_timer.timeout.connect(_on_drop_reset_timer_timeout)

	drop_timer.wait_time = drop_time
	drop_reset_timer.wait_time = reset_time

func _physics_process(_delta: float) -> void:
	if is_dropping:
		position.y -= 0.1

func _on_player_detection_area_body_entered(body: Node) -> void:
	if body is Player:
		player = body as Player
		is_player_on_platform = true
		drop_timer.start()
		play_randomized_animation_with_speed("wobble")

func _on_player_detection_area_body_exited(body: Node) -> void:
	if body is Player:
		is_player_on_platform = false
		player = null

func _on_drop_timer_timeout() -> void:
	drop()

func _on_drop_reset_timer_timeout() -> void:
	reset()

func play_randomized_animation_with_speed(animation_name: String) -> void:
	var speed = randf_range(0.5, 1.5) * (1 if randi() % 2 == 0 else -1) # Randomize speed and direction
	animation_player.play(animation_name)
	animation_player.speed_scale = speed

func reset() -> void:
	is_dropping = false
	card.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	card.material.albedo_color.a = 0.0
	global_transform.origin = original_position
	card.collision_layer = 1
	card.collision_mask = 0
	animation_player.play("fade_in")
	await animation_player.animation_finished
	card.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED

func drop() -> void:
	animation_player.stop()
	animation_player.speed_scale = original_animation_speed_scale
	card.collision_layer = 0
	card.collision_mask = 1
	is_dropping = true

	# Give the player a slight nudge to trigger the collision detection
	if is_player_on_platform and player.is_on_floor():
		player.velocity.y += 0.001

	drop_reset_timer.start()
