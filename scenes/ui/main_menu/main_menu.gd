class_name MainMenu
extends Control

const PORT: int = 3000
const ADDRESS: String = "127.0.0.1"

@onready var host_button: Button = %HostButton
@onready var join_button: Button = %JoinButton


func _ready() -> void:
	host_button.pressed.connect(_on_host_pressed)
	join_button.pressed.connect(_on_join_pressed)
	multiplayer.peer_connected.connect(_on_peer_connected)


func _on_host_pressed() -> void:
	var server_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	server_peer.create_server(PORT)
	multiplayer.multiplayer_peer = server_peer


func _on_join_pressed() -> void:
	var client_peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	client_peer.create_client(ADDRESS, PORT)
	multiplayer.multiplayer_peer = client_peer


func _on_peer_connected(id: int) -> void:
	Util.print_with_id("Peer connected with id=%s" % Util.format_peer_id(id), multiplayer)
