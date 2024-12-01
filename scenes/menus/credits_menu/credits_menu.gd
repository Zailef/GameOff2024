extends Control
class_name CreditsMenu

@onready var back_button = %BackButton

var main_menu: PackedScene = load("res://scenes/menus/main_menu/main_menu.tscn")

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	back_button.pressed.connect(_on_back_button_pressed)
	MenuMusicPlayer.menu_music_requested.emit()

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
