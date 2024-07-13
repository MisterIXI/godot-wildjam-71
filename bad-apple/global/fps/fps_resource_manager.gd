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
		health = value
		health_changed.emit(health)

@export var armor : int = 100:
	get:
		return armor
	set(value):
		armor = value
		armor_changed.emit(armor)

@onready var _start_weapon : WEAPOND_TYPE = weapon
@onready var _start_ammo : int = ammo
@onready var _start_health : int = health
@onready var _start_armor : int = armor


signal weapon_changed(weapon : WEAPOND_TYPE)
signal ammo_changed(ammo : int)
signal health_changed(health : int)
signal armor_changed(armor : int)

func change_resource(resource : String, delta : int) -> void:
	match resource:
		"ammo":
			set("ammo", ammo + delta)
		"health":
			set("health", health + delta)
		"armor":
			set("armor", armor + delta)
		_:
			print("Resource not found: " + resource)


func reset() -> void:
	weapon = _start_weapon
	ammo = _start_ammo
	health = _start_health
	armor = _start_armor
