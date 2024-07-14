extends Area3D

func _ready():
	area_entered.connect(_on_area_entered)
	area_exited.connect(_on_area_exited)


func _on_area_entered(area):
	if area.is_in_group("Medkit"):
		if FpsResourceManagerInstance.health == 100:
			return
		FpsResourceManagerInstance.change_resource("health", FpsResourceManagerInstance.medkit_value)
		area.get_parent().free()
	elif area.is_in_group("Ammo"):
		FpsResourceManagerInstance.change_resource("ammo", FpsResourceManagerInstance.ammo_value)
		area.get_parent().free()
	elif area.is_in_group("Key"):
		FpsResourceManagerInstance.change_resource("key", 1)
		area.get_parent().free()
	elif area.is_in_group("Animation"):
		area.get_parent().play()


func _on_area_exited(area):
	if area.is_in_group("Animation"):
		area.get_parent().reverse(0.5)