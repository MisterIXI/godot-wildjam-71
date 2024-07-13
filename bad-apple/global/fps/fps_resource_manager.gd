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
		if value < health:
			health_damaged.emit()
		elif value > health:
			health_healed.emit()
		health = value
		health = clamp(health, 0, 100)
		health_changed.emit(health)

@export var armor : int = 100:
	get:
		return armor
	set(value):
		if value < armor:
			armor_damaged.emit()
		elif value > armor:
			armor_healed.emit()
		armor = value
		health = clamp(health, 0, 100)
		armor_changed.emit(armor)

@onready var _start_weapon : WEAPOND_TYPE = weapon
@onready var _start_ammo : int = ammo
@onready var _start_health : int = health
@onready var _start_armor : int = armor


signal weapon_changed(weapon : WEAPOND_TYPE)
signal ammo_changed(ammo : int)
signal health_changed(health : int)
signal health_damaged()
signal health_healed()
signal armor_changed(armor : int)
signal armor_damaged()
signal armor_healed()

func change_resource(resource : String, delta : int) -> void:
	match resource:
		"ammo":
			set("ammo", ammo + delta)
		"health":
			set("health", health + delta)
		"armor":
			if armor - delta < 0:
				set("health", health + armor - delta)
				set("armor", 0)
			else:
				set("armor", armor + delta)
		_:
			print("Resource not found: " + resource)


func reset() -> void:
	weapon = _start_weapon
	ammo = _start_ammo
	health = _start_health
	armor = _start_armor
