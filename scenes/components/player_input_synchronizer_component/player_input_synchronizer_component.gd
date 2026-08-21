class_name PlayerInputSynchronizerComponent
extends MultiplayerSynchronizer

@export var _aim_root: Node2D

var movement_vector: Vector2 = Vector2.ZERO
var aim_vector: Vector2 = Vector2.RIGHT
var is_attack_pressed: bool = false


func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		collect_input()


func collect_input() -> void:
	movement_vector = Input.get_vector("left", "right", "up", "down")
	aim_vector = _aim_root.global_position.direction_to(_aim_root.get_global_mouse_position())
	is_attack_pressed = Input.is_action_pressed("attack")
