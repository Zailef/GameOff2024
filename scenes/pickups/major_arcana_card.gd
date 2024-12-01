extends Node3D
class_name MajorArcanaCard

const ANIMATION_FADE_OUT: String = "fade_out"

@export var card_name: String
@export var card_texture: Texture

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var pickup_area: Area3D = $PickupArea
@onready var card_model: CSGBox3D = $CardModel
@onready var pickup_sound: AudioStreamPlayer = $PickupSound

func _ready() -> void:
	card_model.material.normal_texture = card_texture
	pickup_area.body_entered.connect(_on_pickup_area_body_entered)

func _on_pickup_area_body_entered(body: Node3D) -> void:
	if not body is Player:
		return
	
	animation_player.play(ANIMATION_FADE_OUT)
	pickup_sound.play()
	SignalManager.major_arcana_card_collected.emit(card_name)
	await animation_player.animation_finished
	queue_free()
