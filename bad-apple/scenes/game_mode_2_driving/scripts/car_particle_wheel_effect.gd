extends CPUParticles3D

@export var car_vehicle : VehicleBody3D


func _process(_delta):

	if car_vehicle == null:
		return
	var new_amount = maxi(1, int (car_vehicle.linear_velocity.x*5))
	print(new_amount)
	amount = new_amount
