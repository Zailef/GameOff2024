extends ColorRect
class_name ScreenFlames

@onready var death_timer: Timer = $DeathTimer
@onready var recovery_timer: Timer = $RecoveryTimer
@onready var recovery_delay_timer: Timer = $RecoveryDelayTimer

@export var current_intensity: float = 0.0:
	set(value):
		current_intensity = clamp(value, 0.0, 1.0)
		material.set_shader_parameter(shader_intensity, current_intensity)

@export var intensity_increase: float = 0.075
@export var intensity_decrease: float = 0.1

const shader_intensity: String = "intensity"

func _ready() -> void:
	SignalManager.player_entered_fire_area.connect(_on_player_entered_fire_area)
	SignalManager.player_exited_fire_area.connect(_on_player_exited_fire_area)

	death_timer.timeout.connect(_on_death_timer_timeout)
	recovery_timer.timeout.connect(_on_recovery_timer_timeout)
	recovery_delay_timer.timeout.connect(_on_recovery_delay_timer_timeout)

	material.set_shader_parameter(shader_intensity, current_intensity)

func _on_player_entered_fire_area() -> void:
	death_timer.start()
	if not recovery_delay_timer.is_stopped():
		recovery_delay_timer.stop()
		recovery_timer.stop()

func _on_player_exited_fire_area() -> void:
	if not death_timer.is_stopped():
		death_timer.stop()

	recovery_delay_timer.start()

func _on_death_timer_timeout() -> void:
	if not recovery_timer.is_stopped():
		recovery_timer.stop()

	if current_intensity == 1.0:
		SignalManager.player_died.emit()
		current_intensity = 0.0
		death_timer.stop()
		recovery_timer.stop()
		recovery_delay_timer.stop()
	else:
		current_intensity += intensity_increase
	death_timer.start()

func _on_recovery_timer_timeout() -> void:
	if not death_timer.is_stopped():
		death_timer.stop()

	current_intensity -= intensity_decrease
	recovery_delay_timer.start()

func _on_recovery_delay_timer_timeout() -> void:
	recovery_delay_timer.stop()
	recovery_timer.start()
