class_name Main
extends Node


func _ready() -> void:
	Util.print_with_id("_ready, invoking peer_ready.rpc_id(Constants.HOST_ID)", multiplayer)
	peer_ready.rpc_id(Constants.HOST_ID)


@rpc("any_peer", "call_local")
func peer_ready() -> void:
	Util.print_with_id("Peer %s ready" % Util.format_peer_id(multiplayer.get_remote_sender_id()), multiplayer)
