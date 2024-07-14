class_name FpsWeaponChanger
extends Node

@export var shotgun_node : Node3D
@export var knife_node : Node3D

var _next_time : float = 0

func _ready():
	select_weapon(FpsResourceManagerInstance.get("weapon"))

func _unhandled_input(_event):
	if Input.is_action_just_pressed("mmb") and _next_time < Time.get_ticks_msec():
		_next_time = Time.get_ticks_msec() + 100
		
		if FpsResourceManagerInstance.get("weapon") == FpsResourceManager.WEAPOND_TYPE.SHOTGUN:
			select_weapon(FpsResourceManager.WEAPOND_TYPE.KNIFE)
		else:
			select_weapon(FpsResourceManager.WEAPOND_TYPE.SHOTGUN)


func select_weapon(weapon : FpsResourceManager.WEAPOND_TYPE):
	match weapon:
		FpsResourceManager.WEAPOND_TYPE.SHOTGUN:
			FpsResourceManagerInstance.set("weapon", FpsResourceManager.WEAPOND_TYPE.SHOTGUN)
			shotgun_node.visible = true
			knife_node.visible = false
		FpsResourceManager.WEAPOND_TYPE.KNIFE:
			FpsResourceManagerInstance.set("weapon", FpsResourceManager.WEAPOND_TYPE.KNIFE)
			shotgun_node.visible = false
			knife_node.visible = true
