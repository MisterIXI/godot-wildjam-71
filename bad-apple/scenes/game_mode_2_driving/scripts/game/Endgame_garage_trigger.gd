extends Area3D



func _on_body_entered(body:Node3D):
	if body != null:
		get_tree().change_scene_to_packed.call_deferred(GlobMenu.ShootingScene)