extends Area3D
var allready_done :bool = false

func _on_body_entered(_body:Node3D):
	print ("player entered")
	if allready_done:
		return
	Driving_Stage_Manager.next_chunk.emit()
	allready_done = true
