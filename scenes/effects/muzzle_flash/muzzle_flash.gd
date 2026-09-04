class_name MuzzleFlash
extends GPUParticles2D

const SCENE = preload("uid://d4g4xpd3v7q5")


static func create(initial_position: Vector2, initial_rotation: float) -> MuzzleFlash:
	var muzzle_flash: MuzzleFlash = SCENE.instantiate()
	muzzle_flash.global_position = initial_position
	muzzle_flash.rotation = initial_rotation
	return muzzle_flash
