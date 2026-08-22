class_name EnemyManager
extends Node

const ROUND_BASE_TIME: int = 10
const ROUND_GROWTH: int = 5
const BASE_ENEMY_SPAWN_TIME: float = 2.0
const ENEMY_SPAWN_TIME_GROWTH: float = -0.15

@export var enemy_spawn_root: Node
@export var spawn_rectangle: ReferenceRect

var _round_count: int = 0
var _enemy_count: int = 0

@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer
@onready var round_timer: Timer = $RoundTimer


func _ready() -> void:
	Events.enemy_died.connect(_on_enemy_died)
	spawn_interval_timer.timeout.connect(_on_spawn_timer_interval_timer_timeout)
	round_timer.timeout.connect(_on_round_timer_timeout)
	start_round()


func start_round() -> void:
	_round_count += 1
	round_timer.wait_time = ROUND_BASE_TIME + (_round_count - 1) * ROUND_GROWTH
	round_timer.start()

	spawn_interval_timer.wait_time = BASE_ENEMY_SPAWN_TIME + \
			(_round_count - 1) * ENEMY_SPAWN_TIME_GROWTH
	spawn_interval_timer.start()

	Log.info("Starting round %d" % _round_count, multiplayer)


func check_round_completed() -> void:
	if not round_timer.is_stopped():
		return

	if _enemy_count == 0:
		Log.info("Round complete", multiplayer)
		start_round()


func spawn_walker() -> void:
	if not is_multiplayer_authority():
		return
	var walker: Walker = Walker.create()
	walker.global_position = _get_random_spawn_position()
	Log.info("Adding Walker=%s to scene tree" % walker, multiplayer)
	enemy_spawn_root.add_child(walker, true)
	_enemy_count += 1


func _on_spawn_timer_interval_timer_timeout() -> void:
	spawn_walker()
	spawn_interval_timer.start()


func _on_round_timer_timeout() -> void:
	spawn_interval_timer.stop()
	Log.info("Round over", multiplayer)

	if is_multiplayer_authority():
		check_round_completed()


func _on_enemy_died() -> void:
	_enemy_count -= 1
	check_round_completed()


func _get_random_spawn_position() -> Vector2:
	var x: float = randf_range(0, spawn_rectangle.size.x)
	var y: float = randf_range(0, spawn_rectangle.size.y)
	return spawn_rectangle.global_position + Vector2(x, y)
