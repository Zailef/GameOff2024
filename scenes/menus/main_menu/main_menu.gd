extends Control
class_name MainMenu

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

var settings_menu_scene: PackedScene = preload("res://scenes/menus/settings_menu/settings_menu.tscn")
var credits_menu_scene: PackedScene = preload("res://scenes/menus/credits_menu/credits_menu.tscn")
var main_level: PackedScene = preload("res://scenes/levels/sandbox.tscn")

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)
    settings_button.pressed.connect(_on_settings_button_pressed)
    credits_button.pressed.connect(_on_credits_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)
    MenuMusicPlayer.menu_music_requested.emit()

func _on_play_button_pressed() -> void:
    get_tree().change_scene_to_packed(main_level)

func _on_settings_button_pressed() -> void:
    get_tree().change_scene_to_packed(settings_menu_scene)

func _on_credits_button_pressed() -> void:
    get_tree().change_scene_to_packed(credits_menu_scene)

func _on_quit_button_pressed() -> void:
    get_tree().quit()
