class_name Weapon
extends Node2D

const SCENE: PackedScene = preload("uid://qotgk8p5idmu")
const M_16: WeaponResource = preload("uid://c7dmdbsn6eup0")

var resource: WeaponResource
var spawn_node: Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var muzzle: Marker2D = $Muzzle
@onready var sprite_2d: Sprite2D = $Sprite2D


static func create(parent_node: Node) -> Weapon:
	var weapon: Weapon = SCENE.instantiate()
	weapon.resource = M_16
	weapon.spawn_node = parent_node
	return weapon


func _ready() -> void:
	assert(resource)
	sprite_2d.texture = resource.texture
	sprite_2d.offset = resource.texture_offset
	muzzle.position = resource.muzzle_position


func try_shoot(direction: Vector2) -> void:
	if not is_multiplayer_authority():
		return
	if not fire_rate_timer.is_stopped():
		return
	var bullet: Bullet = Bullet.create(direction)
	bullet.global_position = muzzle.global_position
	spawn_node.add_child(bullet, true)
	fire_rate_timer.start()
	_play_shoot.rpc()


@rpc("authority", "call_local", "unreliable")
func _play_shoot() -> void:
	if animation_player.is_playing():
		animation_player.stop()
	animation_player.play("shoot")
	var muzzle_flash: MuzzleFlash = MuzzleFlash.create(
		muzzle.global_position,
		muzzle.global_rotation,
	)
	spawn_node.add_child(muzzle_flash)
