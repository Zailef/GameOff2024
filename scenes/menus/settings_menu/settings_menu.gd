extends Control
class_name SettingsMenu

@onready var back_button: Button = %BackButton
@onready var sound_effect_slider: HSlider = %SFXVolumeSlider
@onready var music_slider: HSlider = %MusicVolumeSlider
@onready var master_slider: HSlider = %MasterVolumeSlider
@onready var sfx_sampler: AudioStreamPlayer = $SFXSampler
@onready var music_sampler: AudioStreamPlayer = $MusicSampler
@onready var master_sampler: AudioStreamPlayer = $MasterSampler

var main_menu_scene: PackedScene = load("res://scenes/menus/main_menu/main_menu.tscn")

func _ready() -> void:
	set_process(false)

	back_button.pressed.connect(_on_back_button_pressed)

	sound_effect_slider.value_changed.connect(_on_sound_effect_slider_value_changed)
	music_slider.value_changed.connect(_on_music_slider_value_changed)
	master_slider.value_changed.connect(_on_master_slider_value_changed)
	MenuMusicPlayer.menu_music_requested.emit()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu_scene)

func _on_master_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), _linear_to_db(clamp(value, 0, 1)))
	master_sampler.play()

func _on_sound_effect_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), _linear_to_db(clamp(value, 0, 1)))
	sfx_sampler.play()

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), _linear_to_db(clamp(value, 0, 1)))
	music_sampler.play()

func _linear_to_db(value: float) -> float:
	if value == 0:
		return -80
	else:
		return 20 * log(value) / log(10)
