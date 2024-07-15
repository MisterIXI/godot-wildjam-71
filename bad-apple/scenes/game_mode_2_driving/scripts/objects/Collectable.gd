extends Node3D


@onready var anim : AnimationPlayer =$AnimationPlayer
var allready_done : bool = false

func _on_area_3d_body_entered(_body:Node3D):
	print(_body)
	if _body != null && !allready_done:
		anim.play("hit")
		#### ADD COIN TO MANAGER
		allready_done = true