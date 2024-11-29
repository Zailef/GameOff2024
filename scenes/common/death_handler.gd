extends Node3D

@onready var kill_field: Area3D = $KillField

var player: Player
var is_player_in_kill_field: bool = false

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

	kill_field.body_entered.connect(_on_body_entered)
	kill_field.body_exited.connect(_on_body_exited)

	SignalManager.player_died.connect(_on_player_died)

	player = get_tree().get_first_node_in_group("player") as Player

func get_active_spawn_point() -> Marker3D:
	var spawn_cards = get_tree().get_nodes_in_group("spawn_cards")
	
	for spawn_card in spawn_cards:
		spawn_card = spawn_card as SpawnCard

		if spawn_card.is_active_spawn:
			return spawn_card.spawn_point

	return null

func _on_player_died() -> void:
	var spawn_point = get_active_spawn_point()
	player.global_transform.origin = spawn_point.global_transform.origin

func _on_body_entered(_body: Node) -> void:
	is_player_in_kill_field = true

func _on_body_exited(_body: Node) -> void:
	is_player_in_kill_field = false
	SignalManager.player_died.emit()
