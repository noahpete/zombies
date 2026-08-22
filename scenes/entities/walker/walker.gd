class_name Walker
extends CharacterBody2D

const SCENE: PackedScene = preload("uid://cikajgwqagnfl")

var current_health: int = 1
var target_position: Vector2 = Vector2.ZERO

@onready var health_component: HealthComponent = $HealthComponent
@onready var target_timer: Timer = $TargetTimer


static func create() -> Walker:
	var walker: Walker = SCENE.instantiate()
	return walker


func _ready() -> void:
	target_timer.timeout.connect(_on_target_timer_timeout)
	health_component.died.connect(_on_died)

	_get_target()


func _process(delta: float) -> void:
	_multiplayer_authority_process(delta)


func _resolve_bullet_hit(bullet: Bullet) -> void:
	if not is_multiplayer_authority():
		return

	bullet.despawn()


func _multiplayer_authority_process(_delta: float) -> void:
	if not is_multiplayer_authority():
		return

	velocity = global_position.direction_to(target_position) * 100
	move_and_slide()


func _on_target_timer_timeout() -> void:
	_get_target()


func _on_died() -> void:
	if not is_multiplayer_authority():
		return

	Events.emit_enemy_died()
	queue_free()


func _get_target() -> void:
	if not is_multiplayer_authority():
		return

	var players: Array[Node] = get_tree().get_nodes_in_group("player")
	var nearest_player: Player = null
	var nearest_distance_squared: float = INF

	for player_node in players:
		var player: Player = player_node
		if nearest_player == null:
			nearest_player = player
			nearest_distance_squared = nearest_player.global_position.distance_squared_to(
				global_position
			)
			continue

		var player_distance_squared: float = player.global_position.distance_squared_to(
			global_position
		)
		if player_distance_squared < nearest_distance_squared:
			nearest_distance_squared = player_distance_squared
			nearest_player = player

	if nearest_player != null:
		target_position = nearest_player.global_position
