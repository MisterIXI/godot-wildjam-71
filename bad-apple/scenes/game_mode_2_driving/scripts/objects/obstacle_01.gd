extends RigidBody3D

@onready var anim : AnimationPlayer =$AnimationPlayer
var allready_done : bool = false

func _on_area_3d_body_entered(_body:Node3D):
	if _body != null && !allready_done:
		anim.play("hit")
		allready_done = true