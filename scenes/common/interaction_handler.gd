extends Area3D

class_name InteractionHandler

signal interaction_started

@onready var interaction_label: Label3D = $InteractionLabel
@export var label_text = "Press [E] to interact"

func _ready() -> void:
	interaction_label.visible = false
	interaction_label.text = label_text

	area_entered.connect(_on_interaction_area_entered)
	area_exited.connect(_on_interaction_area_exited)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed(ActionNames.INTERACT) and interaction_label.visible:
		interaction_started.emit()
		interaction_label.visible = false

func _on_interaction_area_entered(area: Area3D) -> void:
	if area.get_parent() is Player:
		interaction_label.visible = true
		interaction_label.text = label_text

func _on_interaction_area_exited(area: Area3D) -> void:
	if area.get_parent() is Player:
		interaction_label.visible = false