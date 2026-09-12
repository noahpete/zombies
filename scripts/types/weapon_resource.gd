class_name WeaponResource
extends Resource

enum Type {
	PROJECTILE,
	HITSCAN,
}

enum AmmoType {
	LIGHT,
	MEDIUM,
	HEAVY,
	SHELL,
	EXPLOSIVE,
}

@export_group("General")
@export var name: String
@export var id: int
@export var type: Type

@export_group("Visuals")
@export var texture: Texture2D
@export var texture_offset: Vector2
@export var muzzle_position: Vector2

@export_group("Sounds")
@export var equip_sound: AudioStream
@export var unequip_sound: AudioStream
@export var shoot_sound: AudioStream
@export var reload_sound: AudioStream

@export_group("Ammo")
@export var ammo_type: AmmoType
@export var ammo_per_mag: int
@export var ammo_start_reserve: int

@export_group("Shooting")
@export var is_full_auto: bool
@export var number_projectiles_per_shot: int = 1
@export var min_spread: float
@export var max_spread: float
@export var max_range: float
@export var time_between_shots: float

@export_group("Projectile")
@export var projectile_scene: PackedScene
@export var projectile_speed: float = 800.0
@export var projectile_damage: float = 1.0
@export var projectile_damage_falloff: Curve
@export_range(0.0, 16.0, 0.1) var headshot_multiplier: float = 1.0

@export_group("Muzzle Flash")
@export var muzzle_flash_scene: PackedScene
@export var show_muzzle_flash: bool = true
