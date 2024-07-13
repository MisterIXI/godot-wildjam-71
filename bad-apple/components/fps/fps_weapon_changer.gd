class_name FpsWeaponChanger
extends Node

var _resource_manager : FpsResourceManager
var _next_time : float = 0

func _ready():
	_resource_manager = get_node("%FpsResourceManager")


func _unhandled_input(_event):
	if Input.is_action_just_pressed("mmb") and _next_time < Time.get_ticks_msec():
		_next_time = Time.get_ticks_msec() + 100
		var current_weapon = _resource_manager.get("weapon")

		match current_weapon:
			FpsResourceManager.WEAPOND_TYPE.SHOTGUN:
				_resource_manager.set("weapon", FpsResourceManager.WEAPOND_TYPE.KNIFE)
			FpsResourceManager.WEAPOND_TYPE.KNIFE:
				_resource_manager.set("weapon", FpsResourceManager.WEAPOND_TYPE.SHOTGUN)
