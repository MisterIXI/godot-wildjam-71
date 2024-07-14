extends Node3D

var _attackbox : Area3D
var _anim : AnimationPlayer

var _enemies = []

func _ready():
	for child in get_children():
		if child is AnimationPlayer:
			_anim = child
		elif child is Area3D:
			_attackbox = child

	_attackbox.area_entered.connect(_on_area_entered)
	_attackbox.area_exited.connect(_on_area_exited)
	visibility_changed.connect(_on_visibility_changed)


func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("Enemy"):
		_enemies.append(area)


func _on_area_exited(area: Area3D) -> void:
	if area.is_in_group("Enemy"):
		_enemies.erase(area)

func _on_visibility_changed() -> void:
	if visible and _anim != null:
		_anim.play("select")


func attack() -> void:
	if _anim != null:
		_anim.play("attack")

	for enemy in _enemies:
		pass