class_name FpsResourceManager
extends Node

enum WEAPOND_TYPE {SHOTGUN, KNIFE}

@export var weapon : WEAPOND_TYPE = WEAPOND_TYPE.SHOTGUN:
	get:
		return weapon
	set(value):
		weapon = value
		weapon_changed.emit(weapon)

@export var ammo : int = 20:
	get:
		return ammo
	set(value):
		ammo = value
		ammo_changed.emit(ammo)

@export var health : int = 100:
	get:
		return health
	set(value):
		var _health = health
		health = value
		health = clamp(health, 0, 100)
		if value < _health:
			health_damaged.emit()
		elif value > _health:
			health_healed.emit()
		health_changed.emit(health)

@export var armor : int = 100:
	get:
		return armor
	set(value):
		var _armor = armor
		armor = value
		armor = clamp(armor, 0, 100)
		if value < _armor:
			armor_damaged.emit()
		elif value > _armor:
			armor_healed.emit()
		armor_changed.emit(armor)

@export var has_key : bool = false:
	get:
		return has_key
	set(value):
		has_key = value
		if has_key:
			key_found.emit()

@export var medkit_value : int = 20
@export var ammo_value : int = 10
@export var armor_heal_delay : float = 10.0
@export var armor_heal_time : float = 0.04

@export var shotgut_cooldown : float = 1
@export var bullet_damage : int = 20

@onready var _start_weapon : WEAPOND_TYPE = weapon
@onready var _start_ammo : int = ammo
@onready var _start_health : int = health
@onready var _start_armor : int = armor
@onready var _start_has_key : bool = has_key


signal weapon_changed(weapon : WEAPOND_TYPE)
signal ammo_changed(ammo : int)
signal health_changed(health : int)
signal health_damaged()
signal health_healed()
signal armor_changed(armor : int)
signal armor_damaged()
signal armor_healed()
signal key_found()

func change_resource(resource : String, delta : int) -> void:
	match resource:
		"ammo":
			set("ammo", ammo + delta)
		"health":
			set("health", health + delta)
		"armor":
			if armor + delta < 0:
				set("health", health + armor + delta)
				set("armor", 0)
			else:
				set("armor", armor + delta)
		"key":
			has_key = true
			key_found.emit()
		_:
			print("Resource not found: " + resource)


func reset() -> void:
	weapon = _start_weapon
	ammo = _start_ammo
	health = _start_health
	armor = _start_armor
	has_key = _start_has_key
