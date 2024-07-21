extends Area3D



func _on_body_entered(body:Node3D):
	if body != null:
		endgame.call_deferred()
		

func endgame():
	get_tree().change_scene_to_packed(GlobMenu.ShootingScene)