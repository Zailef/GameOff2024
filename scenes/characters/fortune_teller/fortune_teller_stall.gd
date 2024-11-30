extends Node3D
class_name FortuneTellerStall

const ANIMATION_INTERACT_TRANSITION: String = "interact_transition"
const ANIMATION_TALKING: String = "talking"
const ANIMATION_IDLE: String = "idle"

@onready var interaction_handler: InteractionHandler = $InteractionHandler
@onready var animation_player: AnimationPlayer = $FortuneTellerCharacter/AnimationPlayer

func _ready() -> void:
	interaction_handler.interaction_started.connect(_on_interaction_started)
	animation_player.play(ANIMATION_IDLE)

func _on_interaction_started() -> void:
	print("Started talking to the fortune teller")
	animation_player.play(ANIMATION_INTERACT_TRANSITION)
	await animation_player.animation_finished
	animation_player.play(ANIMATION_TALKING)
