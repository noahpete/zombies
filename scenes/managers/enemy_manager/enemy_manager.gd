class_name EnemyManager
extends Node

@export var enemy_spawn_root: Node
@export var spawn_rectangle: ReferenceRect

@onready var spawn_interval_timer: Timer = $SpawnIntervalTimer


func _ready() -> void:
	spawn_interval_timer.timeout.connect(_on_spawn_timer_interval_timer_timeout)


func spawn_walker() -> void:
	if not is_multiplayer_authority():
		return
	var walker: Walker = Walker.create()
	walker.global_position = _get_random_spawn_position()
	enemy_spawn_root.add_child(walker, true)


func _get_random_spawn_position() -> Vector2:
	var x: float = randf_range(0, spawn_rectangle.size.x)
	var y: float = randf_range(0, spawn_rectangle.size.y)
	return spawn_rectangle.global_position + Vector2(x, y)


func _on_spawn_timer_interval_timer_timeout() -> void:
	spawn_walker()
