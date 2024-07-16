class_name FpsDoor
extends Area3D

@export var object : MeshInstance3D
@export var animation_time : float = 1.0
@export var y_offset : float = -10.0
@export var one_shot : bool = false
@export var need_key: bool = false


var _key_text : Label
var _start_position : float
var _end_position : float
var _current_tween : Tween


func _ready():
	_key_text = get_tree().root.get_child(-1).get_node("FpsHud").get_node("%NeedKey")
	if not _key_text:
		assert(false, "FpsHud needs to be in the scene and has to have a child named %NeedKey. Path: " + str(get_path()))

	add_to_group("Door")

	_start_position = object.position.y
	_end_position = _start_position + y_offset



func play() -> void:
	if need_key and !FpsResourceManagerInstance.has_key:
		_key_text.show()
		return

	_current_tween = create_tween()
	_current_tween.tween_property(object, "position:y", _end_position, _get_animation_time(true))

	if one_shot:
		await _current_tween.finished
		queue_free()


func reverse(delay : float) -> void:
	if need_key and !FpsResourceManagerInstance.has_key:
		return
	
	if one_shot:
		return

	await get_tree().create_timer(delay).timeout

	if _current_tween:
		_current_tween.kill()
		_current_tween = create_tween()
		_current_tween.tween_property(object, "position:y", _start_position, _get_animation_time(false))


func _get_animation_time(forward : bool) -> float:
	var goal : float
	if forward:
		goal = _end_position
	else:
		goal = _start_position

	var distance = abs(object.position.y - goal)
	return distance / abs(y_offset) * animation_time
