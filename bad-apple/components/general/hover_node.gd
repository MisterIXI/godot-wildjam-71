class_name HoverNode
extends Node

@export var is_bobbing: bool = true
@export var boobing_time: float = 2.0
@export var bobbing_height: float = 0.1

@export var is_rotating: bool = true
@export var rotation_time: float = 8

var _parent: Node3D

func _ready():
	_parent = get_parent()

	if is_bobbing:
		var tween_bob = _parent.create_tween()
		tween_bob.set_ease(Tween.EASE_IN_OUT)
		tween_bob.set_trans(Tween.TRANS_SINE)
		tween_bob.tween_property(_parent, "position", _parent.position + (bobbing_height * Vector3(0,1,0)), boobing_time)
		tween_bob.tween_property(_parent, "position", _parent.position - (bobbing_height * Vector3(0,1,0)), boobing_time)
		tween_bob.set_loops()
	if is_rotating:
		var tween_rot = _parent.create_tween()
		var rotator = func(value:float):
			_parent.rotation_degrees.y = value
		tween_rot.tween_method(rotator, 0,360.1,rotation_time)
		tween_rot.set_loops()
