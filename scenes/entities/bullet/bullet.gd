class_name Bullet
extends Node2D

const SPEED: int = 800
const SCENE = preload("uid://dqt2vor1gri6h")

var _direction: Vector2

@onready var life_timer: Timer = $LifeTimer
@onready var hitbox_component: HitboxComponent = $HitboxComponent


static func create(direction: Vector2) -> Bullet:
	var bullet: Bullet = SCENE.instantiate()
	bullet.rotation = direction.angle()
	bullet._direction = direction
	return bullet


func _ready() -> void:
	hitbox_component.hit_hurtbox.connect(_on_hit_hurtbox)
	life_timer.timeout.connect(_on_life_timer_timeout)


func _physics_process(delta: float) -> void:
	global_position += _direction * SPEED * delta


func despawn() -> void:
	if not is_multiplayer_authority():
		return
	queue_free()


func _on_life_timer_timeout() -> void:
	despawn()


func _on_hit_hurtbox(_hurtbox_component: HurtboxComponent) -> void:
	despawn()
