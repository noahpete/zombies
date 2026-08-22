class_name Walker
extends CharacterBody2D

@onready var area_2d: Area2D = $Area2D


func _ready() -> void:
	area_2d.area_entered.connect(_on_area_entered)


func _on_area_entered(other_area: Area2D) -> void:
	if other_area.owner is Bullet:
		_resolve_bullet_hit(other_area.owner)


func _resolve_bullet_hit(bullet: Bullet) -> void:
	if not is_multiplayer_authority():
		return
	bullet.despawn()
