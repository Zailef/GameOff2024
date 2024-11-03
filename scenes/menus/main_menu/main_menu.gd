extends Control

@onready var play_button: Button = %PlayButton
@onready var settings_button: Button = %SettingsButton
@onready var credits_button: Button = %CreditsButton
@onready var quit_button: Button = %QuitButton

func _ready() -> void:
    play_button.pressed.connect(_on_play_button_pressed)
    settings_button.pressed.connect(_on_settings_button_pressed)
    credits_button.pressed.connect(_on_credits_button_pressed)
    quit_button.pressed.connect(_on_quit_button_pressed)

func _on_play_button_pressed() -> void:
    pass

func _on_settings_button_pressed() -> void:
    pass

func _on_credits_button_pressed() -> void:
    pass

func _on_quit_button_pressed() -> void:
    get_tree().quit()
