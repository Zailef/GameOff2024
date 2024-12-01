extends Node3D
class_name MajorArcanaCard

const ANIMATION_FADE_OUT: String = "fade_out"

@export var card_name: String
@export var card_texture: Texture

@onready var interaction_handler: InteractionHandler = $InteractionHandler
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var card_model: CSGBox3D = $CardModel

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	card_model.material.normal_texture = card_texture

func _on_interaction_started() -> void:
	animation_player.play(ANIMATION_FADE_OUT)
	SignalManager.major_arcana_card_collected.emit(card_name)
	await animation_player.animation_finished
	queue_free()
