class_name FpsArmorHealer
extends Node

var _tweens : Array = []
func _ready():
	FpsResourceManagerInstance.armor_damaged.connect(_on_damaged)
	FpsResourceManagerInstance.health_damaged.connect(_on_damaged)


func _on_damaged():
	_kill_tweens()
	var tween = FpsResourceManagerInstance.create_tween()
	_tweens.append(tween)
	var tim = FpsResourceManagerInstance.armor_heal_time * (100 - FpsResourceManagerInstance.armor)
	tween.tween_property(FpsResourceManagerInstance, "armor", 100, tim).set_delay(FpsResourceManagerInstance.armor_heal_delay)

func _kill_tweens():
	if _tweens.size() > 0:
		for tween in _tweens:
			if tween.is_valid():
				tween.kill()
	_tweens.clear()