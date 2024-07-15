extends Area3D




func _on_body_entered(_body:Node3D):
	print("player get damage")
	_body.get_hit_speed()
	Driving_Stage_Manager.on_player_get_hit()
