extends Area3D




func _on_body_entered(_body:Node3D):
	print("player get damage")
	_body.get_hit_speed()
	Stage_Manager.instance.on_player_get_hit()
