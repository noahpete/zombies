class_name EnemyManager
extends Node

const ROUND_BASE_TIME: int = 10
const ROUND_GROWTH: int = 5
const BASE_ENEMY_SPAWN_TIME: float = 2.0
const ENEMY_SPAWN_TIME_GROWTH: float = -0.15

@export var enemy_spawn_root: Node
@export var spawn_rectangle: ReferenceRect

@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer
@onready var round_timer: Timer = $RoundTimer

var _round_count: int = 0


func _ready() -> void:
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


func spawn_walker() -> void:
	if not is_multiplayer_authority():
		return
	var walker: Walker = Walker.create()
	walker.global_position = _get_random_spawn_position()
	Log.info("Adding Walker=%s to scene tree" % walker, multiplayer)
	enemy_spawn_root.add_child(walker, true)


func _on_spawn_timer_interval_timer_timeout() -> void:
	spawn_walker()
	spawn_interval_timer.start()


func _on_round_timer_timeout() -> void:
	spawn_interval_timer.stop()
	Log.info("Round over", multiplayer)


func _get_random_spawn_position() -> Vector2:
	var x: float = randf_range(0, spawn_rectangle.size.x)
	var y: float = randf_range(0, spawn_rectangle.size.y)
	return spawn_rectangle.global_position + Vector2(x, y)
