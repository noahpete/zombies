class_name Main
extends Node

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner


func _ready() -> void:
	multiplayer_spawner.spawn_function = func(data: Dictionary) -> Node:
		Util.print_with_id("Instantiating Player with id=%s via multiplayer_spawner.spawn_function" % Util.format_peer_id(data.peer_id), multiplayer)
		var player: Player = Constants.PLAYER_SCENE.instantiate()
		player.name = str(data.peer_id)
		player.input_multiplayer_authority = data.peer_id
		return player

	peer_ready.rpc_id(Constants.HOST_ID)


@rpc("any_peer", "call_local")
func peer_ready() -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	Util.print_with_id("Invoking multiplayer_spawner.spawn from sender with id=%s" % Util.format_peer_id(sender_id), multiplayer)
	multiplayer_spawner.spawn({ "peer_id": sender_id })
