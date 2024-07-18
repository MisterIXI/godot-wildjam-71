extends Node3D


@onready var anim : AnimationPlayer =$AnimationPlayer
var allready_done : bool = false

func _on_area_3d_body_entered(_body:Node3D):
	if _body != null && !allready_done:
		anim.play("died")
		#### ADD COIN TO MANAGER
		allready_done = true
		Driving_Stage_Manager.add_coin_to_wallet()