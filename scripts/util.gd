class_name Util


static func format_peer_id(id: int) -> String:
	return "HOST" if id == Constants.HOST_ID else String.num_int64(id % 10000)


static func print_with_id(message: String, multiplayer_api: MultiplayerAPI) -> void:
	print("[%s] %s" % [format_peer_id(multiplayer_api.get_unique_id()), message])
