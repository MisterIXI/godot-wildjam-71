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
	if _object.is_in_group("Enemy"):
		var _parent = _object
		for i in range(6):
			_parent = _parent.get_parent()
			if _parent is FpsBanana:
				_parent.damage()
				_particles.material_override = damage_material
				break
	
	_particles.emitting = true
	await _particles.finished
	queue_free()
