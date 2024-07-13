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


signal weapon_changed(weapon : WEAPOND_TYPE)
signal ammo_changed(ammo : int)
signal health_changed(health : int)
signal armor_changed(armor : int)
