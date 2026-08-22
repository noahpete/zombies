class_name Bullet
extends Node2D

const SCENE = preload("uid://dqt2vor1gri6h")
const SPEED: int = 800

@onready var life_timer: Timer = $LifeTimer

var _direction: Vector2


static func create(direction: Vector2) -> Bullet:
	var bullet: Bullet = SCENE.instantiate()
	bullet.rotation = direction.angle()
	bullet._direction = direction
	return bullet


func _ready() -> void:
	life_timer.timeout.connect(_on_life_timer_timeout)


func _physics_process(delta: float) -> void:
	global_position += _direction * SPEED * delta


func despawn() -> void:
	if not is_multiplayer_authority():
		return
	queue_free()

func _on_life_timer_timeout() -> void:
	despawn()
