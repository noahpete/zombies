class_name Player
extends CharacterBody2D

const SCENE: PackedScene = preload("uid://djfdsbvq73ne4")
const BLEND_SPEED: float = 8.0

@export var max_speed: float = 80.0

var is_active: bool = true
var input_multiplayer_authority: int

@onready var player_input_synchronizer_component: PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var health_component: HealthComponent = $HealthComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var visuals: Node2D = $Visuals
@onready var weapon_root: Node2D = $Visuals/WeaponRoot
@onready var muzzle_position: Marker2D = %MuzzlePosition


static func create(peer_id: int) -> Player:
	var player: Player = SCENE.instantiate()
	player.name = str(peer_id)
	player.input_multiplayer_authority = peer_id
	return player


func _ready() -> void:
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)

	if is_multiplayer_authority():
		health_component.died.connect(_on_died)


func _process(delta: float) -> void:
	_update_aim_position()

	var movement_vector: Vector2 = player_input_synchronizer_component.movement_vector

	var target_blend: float = 1.0 if movement_vector.length() > 0.0 else 0.0
	var current_blend: float = animation_tree["parameters/movement/blend_position"]
	animation_tree["parameters/movement/blend_position"] = move_toward(
		current_blend,
		target_blend,
		BLEND_SPEED * delta,
	)

	_multiplayer_authority_process(delta)


func _multiplayer_authority_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return

	if not is_active:
		global_position = Vector2.RIGHT * 10e6
		return

	if player_input_synchronizer_component.is_attack_pressed:
		_try_shoot()

	velocity = player_input_synchronizer_component.movement_vector * max_speed
	move_and_slide()


func deactivate() -> void:
	Log.info("Player %s die" % Log.format_peer_id(int(name)), multiplayer)
	_deactivate_rpc.rpc()
	await get_tree().create_timer(0.2).timeout
	queue_free()


func _update_aim_position() -> void:
	var aim_vector: Vector2 = player_input_synchronizer_component.aim_vector
	var aim_position: Vector2 = weapon_root.global_position + aim_vector
	visuals.scale.x = 1 if aim_vector.x >= 0 else -1
	weapon_root.look_at(aim_position)


@rpc("authority", "call_local", "reliable")
func _deactivate_rpc() -> void:
	is_active = false
	player_input_synchronizer_component.public_visibility = false


func _on_died() -> void:
	deactivate()


@rpc("authority", "call_local", "unreliable")
func _play_shoot() -> void:
	animation_tree["parameters/shoot_one_shot/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

	var muzzle_flash: MuzzleFlash = MuzzleFlash.create(
		muzzle_position.global_position,
		muzzle_position.global_rotation,
	)
	get_parent().add_child(muzzle_flash)


func _try_shoot() -> void:
	if not is_multiplayer_authority():
		return
	if not fire_rate_timer.is_stopped():
		return
	var bullet: Bullet = Bullet.create(player_input_synchronizer_component.aim_vector)
	bullet.global_position = muzzle_position.global_position
	get_parent().add_child(bullet, true)
	fire_rate_timer.start()
	_play_shoot.rpc()
