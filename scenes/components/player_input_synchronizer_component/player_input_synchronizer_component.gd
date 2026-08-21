class_name PlayerInputSynchronizerComponent
extends MultiplayerSynchronizer

var input_vector: Vector2 = Vector2.ZERO


func _process(_delta: float) -> void:
	if is_multiplayer_authority():
		update_input_vector()


func update_input_vector() -> void:
	input_vector = Input.get_vector("left", "right", "up", "down")
