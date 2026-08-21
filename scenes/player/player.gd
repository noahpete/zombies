class_name Player
extends CharacterBody2D

const BLEND_SPEED: float = 8.0

@export var max_speed: float = 60.0

@onready var player_input_synchronizer_component: PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var visuals: Node2D = $Visuals

var input_multiplayer_authority: int


func _ready() -> void:
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)
	set_physics_process(is_multiplayer_authority())


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = player_input_synchronizer_component.input_vector

	var target_blend: float = 1.0 if input_vector.length() > 0.0 else 0.0
	var current_blend: float = animation_tree["parameters/blend_position"]
	animation_tree["parameters/blend_position"] = move_toward(current_blend,
		target_blend, BLEND_SPEED * delta)

	if input_vector.x != 0:
		visuals.scale.x = -1 if input_vector.x < 0 else 1

	velocity = input_vector * max_speed
	move_and_slide()
