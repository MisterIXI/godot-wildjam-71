extends Node3D

@export var bullet : PackedScene
@export var camera: Camera3D
@export var targets : Node3D

var _anim: AnimationPlayer
var _light: OmniLight3D
var _next_time = 0.0

var _rays = []

func _ready():
	for child in get_children():
		if child is AnimationPlayer:
			_anim = child
		elif child is OmniLight3D:
			_light = child
	
	for target in targets.get_children():
		var ray = RayCast3D.new()
		targets.add_child(ray)
		ray.position = Vector3(0, 0, 0)
		ray.target_position = target.position
		ray.enabled = true
		ray.name = "ray: " + str(target.name)
		_rays.append(ray)


	visibility_changed.connect(_on_visibility_changed)


func _on_visibility_changed() -> void:
	if visible and _anim != null:
		_anim.play("select")


func _unhandled_input(_event) -> void:
	if visible and Input.is_action_just_pressed("lmb"):
		if FpsResourceManagerInstance.ammo > 0 and Time.get_ticks_msec() > _next_time:
			_shoot()


func _shoot() -> void:
	if _anim != null:
		_anim.play("attack")
	
	var tween = _light.create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(_light, "light_energy", 0.7, 0.03)
	tween.tween_property(_light, "light_energy", 0, 0.03)

	FpsResourceManagerInstance.change_resource("ammo", -1)

	for ray in _rays:
		if ray.is_colliding():
			var _object = ray.get_collider()
			var _position = ray.get_collision_point()

			var _bullet = bullet.instantiate() as FpsBullet
			_bullet.set_deferred("global_position", _position)
			_bullet.set_deferred("object" , _object)
			get_tree().root.get_child(-1).add_child(_bullet)
		else:
			var _bullet = bullet.instantiate() as FpsBullet
			_bullet.set_deferred("global_position", ray.to_global(ray.target_position))
			_bullet.set_deferred("object" , null)
			get_tree().root.get_child(-1).add_child(_bullet)
	

	_next_time = Time.get_ticks_msec() + FpsResourceManagerInstance.shotgut_cooldown * 1000
