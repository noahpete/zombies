class_name Main
extends Node

const SCENE: PackedScene = preload("uid://dmmubmixwr8u")

@onready var multiplayer_spawner: MultiplayerSpawner = $MultiplayerSpawner
@onready var player_spawn: Marker2D = $World/PlayerSpawn

var players: Dictionary[int, Player]


func _ready() -> void:
	multiplayer_spawner.spawn_function = func(data: Dictionary) -> Node:
		Log.info(
			"Instantiating Player with id=%s via multiplayer_spawner.spawn_function"
			% Log.format_peer_id(data.peer_id),
			multiplayer,
		)
		var player: Player = Player.create(data.peer_id)
		player.global_position = player_spawn.global_position
		players[data.peer_id] = player
		return player

	peer_ready.rpc_id(Constants.HOST_ID)

	if is_multiplayer_authority():
		multiplayer.peer_disconnected.connect(_on_peer_disconnected)


@rpc("any_peer", "call_local")
func peer_ready() -> void:
	var sender_id: int = multiplayer.get_remote_sender_id()
	Log.info(
		"Invoking multiplayer_spawner.spawn from sender with id=%s" % Log.format_peer_id(sender_id),
		multiplayer,
	)
	multiplayer_spawner.spawn({ "peer_id": sender_id })


func _on_peer_disconnected(peer_id: int) -> void:
	if players.has(peer_id):
		var player: Player = players[peer_id]
		if is_instance_valid(player):
			player.deactivate()
		players.erase(peer_id)
