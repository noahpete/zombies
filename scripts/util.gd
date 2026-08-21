class_name Util


static func format_peer_id(peer_id: int) -> String:
	return "HOST" if peer_id == Constants.HOST_ID else "%04d" % (peer_id % 10000)


static func print_with_id(message: String, multiplayer_api: MultiplayerAPI) -> void:
	print("[%s] %s" % [format_peer_id(multiplayer_api.get_unique_id()), message])
