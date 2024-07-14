class_name FpsBullet
extends Node3D

var object : Node3D = null:
	get:
		return object
	set(value):
		object = value
		hit(object)

var start_position : Vector3 = Vector3(0, 0, 0):
	get:
		return start_position
	set(value):
		start_position = value
		_distance = global_position.distance_to(start_position)
		# _scale = ((_distance / FpsResourceManagerInstance.bullet_range) * FpsResourceManagerInstance.bullet_spread) +1

var _distance = 0.0
# var _scale = 1.0
var _particles : CPUParticles3D

func _ready():
	visible = true

	for child in get_children():
		if child is CPUParticles3D:
			_particles = child
			break


func hit(_object : Node3D) -> void:
	_particles.emitting = true

	await _particles.finished
	queue_free()
