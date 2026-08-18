class_name Player
extends CharacterBody2D

@export var max_speed: float = 60.0

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D


func _physics_process(_delta: float) -> void:
	var input_vector: Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_vector.length() > 0:
		animation_player.play("walk")
		sprite_2d.flip_h = input_vector.x < 0
	else:
		animation_player.play("RESET")

	velocity = input_vector * max_speed
	move_and_slide()
