extends Control

@onready var back_button = %BackButton

var main_menu: PackedScene = load("res://scenes/menus/main_menu/main_menu.tscn")

func _ready() -> void:
	back_button.pressed.connect(_on_back_button_pressed)

func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_menu)
