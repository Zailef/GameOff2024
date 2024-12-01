extends MarginContainer

@onready var major_arcana_label: Label = $MajorArcanaLabel

var player: Player

func _ready() -> void:
	player = get_tree().get_first_node_in_group("player") as Player
	SignalManager.major_acrana_card_added_to_inventory.connect(_on_arcana_card_added_to_inventory)

func _on_arcana_card_added_to_inventory(_card_name: String) -> void:
	major_arcana_label.text = "Major Arcana Collected: " + str(player.collected_cards.size()) + "/22"
