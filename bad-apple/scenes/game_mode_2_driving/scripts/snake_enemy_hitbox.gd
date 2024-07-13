extends Area3D




func _on_body_entered(_body:Node3D):
	print("player get damage")
	Driving_Stage_Manager.on_player_get_hit()
