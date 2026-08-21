class_name Player
extends CharacterBody2D

const SCENE: PackedScene = preload("uid://djfdsbvq73ne4")
const BLEND_SPEED: float = 8.0

@export var max_speed: float = 80.0

@onready var player_input_synchronizer_component: PlayerInputSynchronizerComponent = $PlayerInputSynchronizerComponent
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var visuals: Node2D = $Visuals
@onready var weapon_root: Node2D = $WeaponRoot

var input_multiplayer_authority: int


static func create(peer_id: int) -> Player:
	var player: Player = SCENE.instantiate()
	player.name = str(peer_id)
	player.input_multiplayer_authority = peer_id
	return player


func _ready() -> void:
	player_input_synchronizer_component.set_multiplayer_authority(input_multiplayer_authority)


func _process(delta: float) -> void:
	var aim_position = weapon_root.global_position + player_input_synchronizer_component.aim_vector
	weapon_root.look_at(aim_position)

	var movement_vector: Vector2 = player_input_synchronizer_component.movement_vector

	var target_blend: float = 1.0 if movement_vector.length() > 0.0 else 0.0
	var current_blend: float = animation_tree["parameters/blend_position"]
	animation_tree["parameters/blend_position"] = move_toward(current_blend,
		target_blend, BLEND_SPEED * delta)

	if movement_vector.x != 0:
		visuals.scale.x = -1 if movement_vector.x < 0 else 1

	_multiplayer_authority_process()


func _multiplayer_authority_process() -> void:
	if not is_multiplayer_authority():
		return

	if player_input_synchronizer_component.is_attack_pressed:
		var bullet: Bullet = Bullet.create(
			weapon_root.global_position,
			player_input_synchronizer_component.aim_vector
		)
		get_parent().add_child(bullet, true)

	velocity = player_input_synchronizer_component.movement_vector * max_speed
	move_and_slide()
