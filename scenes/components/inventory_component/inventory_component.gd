class_name InventoryComponent
extends Node

@export var weapon_root: Node2D

var primary_weapon: Weapon
var secondary_weapon: Weapon


func get_active_weapon() -> Weapon:
	return primary_weapon
