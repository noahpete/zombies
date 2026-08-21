class_name Bullet
extends Node2D

const SCENE = preload("uid://dqt2vor1gri6h")
const SPEED: int = 800

var _direction: Vector2


static func create(initial_global_position: Vector2, direction: Vector2) -> Bullet:
	var bullet: Bullet = SCENE.instantiate()
	bullet.global_position = initial_global_position
	bullet.rotation = direction.angle()
	bullet._direction = direction
	return bullet


func _physics_process(delta: float) -> void:
	global_position += _direction * SPEED * delta
