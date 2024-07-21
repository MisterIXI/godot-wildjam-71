extends Node3D

var _attackbox : Area3D
var _anim : AnimationPlayer

var _particles : CPUParticles3D
@export var damage_material : Material = null

var _enemies = []

func _ready():
	for child in get_children():
		if child is AnimationPlayer:
			_anim = child
		elif child is Area3D:
			_attackbox = child
		elif child is CPUParticles3D:
			_particles = child

	_attackbox.body_entered.connect(_on_body_entered)
	_attackbox.body_exited.connect(_on_body_exited)
	visibility_changed.connect(_on_visibility_changed)


func _on_body_entered(area) -> void:
	if area.is_in_group("Enemy"):
		_enemies.append(area)


func _on_body_exited(area) -> void:
	if area.is_in_group("Enemy"):
		if area in _enemies:
			_enemies.erase(area)

func _on_visibility_changed() -> void:
	if visible and _anim != null:
		_anim.play("select")

#Phils test funktion
func _unhandled_input(_event) -> void:
	if visible and Input.is_action_just_pressed("lmb"):
		attack()


func attack() -> void:
	if _anim != null:
		_anim.play("attack")


func damage() -> void:
	for enemy in _enemies:
		if enemy and enemy is FpsBanana:
			enemy.knife()
			_particles.emitting = true
	