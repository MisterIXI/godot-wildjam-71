class_name FpsBullet
extends Node3D

@export var damage_material : Material = null

var object : Node3D = null:
	get:
		return object
	set(value):
		object = value
		hit(object)

var _particles : CPUParticles3D

func _ready():
	visible = true

	for child in get_children():
		if child is CPUParticles3D:
			_particles = child
			break


func hit(_object : Node3D) -> void:
	if _object is FpsBanana:
		_object.damage()
		_particles.material_override = damage_material
	
	_particles.emitting = true
	await _particles.finished
	queue_free()
