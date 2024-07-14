class_name FPSAnimationBox
extends Node3D

@export var need_key: bool = false

var key_text : Label
var _anim: AnimationPlayer
var _name: String


func _ready():
	for child in get_children():
		if child is AnimationPlayer:
			_anim = child
			break
	
	key_text = get_tree().root.get_child(-1).get_node("FpsHud").get_node("%NeedKey")

	if not key_text:
		assert(false, "FpsHud needs to be in the scene and has to have a child named %NeedKey. Path: " + str(get_path()))
	
	if _anim == null:
		assert(false, str(name) + " has to have an AnimationPlayer attachted to it. Path: " + str(get_path()))
		return

	_name =_anim.get_animation_list()[1].get_basename()

	if _name == "":
		assert(false, str(name) + " has to have at least one animation. Path: " + str(get_path()))
		return
	


func play() -> void:
	if need_key and !FpsResourceManagerInstance.has_key:
		key_text.show()
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
