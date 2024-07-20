class_name FpsBanana
extends Node3D

@export var _health : int = 100

func damage() -> void:
	_health -= FpsResourceManagerInstance.bullet_damage

	if _health <= 0:
		die()

func die() -> void:
	queue_free()
