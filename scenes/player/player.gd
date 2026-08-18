class_name Player
extends CharacterBody2D

const BLEND_SPEED: float = 8.0

@export var max_speed: float = 60.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var visuals: Node2D = $Visuals


func _physics_process(delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")

	var target_blend: float = 1.0 if input_vector.length() > 0.0 else 0.0
	var current_blend: float = animation_tree["parameters/blend_position"]
	animation_tree["parameters/blend_position"] = move_toward(current_blend,
		target_blend, BLEND_SPEED * delta)

	if input_vector.x != 0:
		visuals.scale.x = -1 if input_vector.x < 0 else 1

	velocity = input_vector * max_speed
	move_and_slide()
