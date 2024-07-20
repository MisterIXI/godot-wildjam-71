class_name FpsBananaBullet
extends Area3D

var player : Node3D:
	get:
		return player
	set(value):
		player = value
		global_rotation = Vector3.ZERO
		look_at(player.global_position + Vector3.UP, Vector3.UP)
		is_flying = true

var speed = 10 # Adjust the speed as needed
var direction = Vector3.FORWARD # Assuming forward is the initial direction
var lifetime = 5.0 # Bullet lifetime in seconds
var is_flying = false

func _process(delta):
	if not is_flying:
		return

	lifetime -= delta
	if lifetime <= 0:
		kill()
	
	# Move the bullet forward
	var move_distance = speed * delta
	translate(direction * move_distance)

func kill():
	queue_free()