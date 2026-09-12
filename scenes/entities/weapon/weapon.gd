class_name Weapon
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var muzzle_position: Marker2D = $MuzzlePosition


func play_animation(animation_name: StringName) -> void:
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play(animation_name)
