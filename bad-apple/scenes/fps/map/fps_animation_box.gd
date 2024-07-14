class_name FPSAnimationBox
extends Node3D

@export var need_key: bool = false

var _anim: AnimationPlayer
var _name: String


func _ready():
	for child in get_children():
		if child is AnimationPlayer:
			_anim = child
			break
	
	if _anim == null:
		assert(false, str(name) + " has to have an AnimationPlayer attachted to it. Path: " + str(get_path()))
		return

	_name =_anim.get_animation_list()[1].get_basename()

	if _name == "":
		assert(false, str(name) + " has to have at least one animation. Path: " + str(get_path()))
		return
	


func play() -> void:
	if need_key and !FpsResourceManagerInstance.has_key:
		return

	if _anim.is_playing():
		_anim.pause()
	_anim.play(_name, -1, 1)


func reverse(delay : float) -> void:
	if need_key and !FpsResourceManagerInstance.has_key:
		return

	if delay > 0:
		await get_tree().create_timer(delay).timeout
	
	if _anim.is_playing():
		_anim.pause()
		_anim.play(_name, -1, -1)
		return
	_anim.play_backwards(_name)
