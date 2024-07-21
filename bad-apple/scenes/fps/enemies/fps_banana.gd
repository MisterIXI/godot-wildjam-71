class_name FpsBanana
extends CharacterBody3D

enum BANANA_STATE {
	IDLE,
	WALK,
	SHOOT,
	REPOSITION,
}

@export var _health : int = 100
@export var shoot_area : Area3D = null
@export var walk_area : Area3D = null
@export var walk_directions : int = 4
@export var anim_player : AnimationPlayer = null
@export var particles : CPUParticles3D = null
@export var model : Node3D = null
@export var bullet : PackedScene = null
@export var barrel: Node3D = null
@export var ammonition : PackedScene = null
@export var collision : CollisionShape3D = null

var player : Node3D = null
var state : BANANA_STATE = BANANA_STATE.IDLE
var goal_pos : Vector3 = Vector3.ZERO
var dummy_node: Node3D = null

var player_is_in_shoot_area : bool = false
var player_ray : RayCast3D = null

var player_is_in_walk_area : bool = false
var walk_rays = []

var is_dead : bool = false

func _ready() -> void:
	shoot_area.area_entered.connect(_on_shoot_area_entered)
	shoot_area.area_exited.connect(_on_shoot_area_exited)

	walk_area.area_entered.connect(_on_walk_area_entered)
	walk_area.area_exited.connect(_on_walk_area_exited)

	player_ray = RayCast3D.new()
	add_child(player_ray)
	player_ray.position = Vector3(0, 1, 0)
	player_ray.target_position = Vector3(0, 1, 0)
	player_ray.enabled = true
	player_ray.name = "player_ray"

	for i in walk_directions:
		var ray = RayCast3D.new()
		add_child(ray)
		ray.position = Vector3(0, 1, 0)
		
		ray.target_position = Vector3.RIGHT.rotated(Vector3.UP, deg_to_rad(i * 360.0 / walk_directions)) * FpsResourceManagerInstance.banana_reposition_distance 
		ray.name = "walk_ray_" + str(i * 360.0 / walk_directions)
		ray.enabled = true
		walk_rays.append(ray)
	dummy_node = Node3D.new()
	add_child(dummy_node)


func _physics_process(delta):
	match state:
		BANANA_STATE.SHOOT:
			if can_see_player():
				look_at(player.global_position * Vector3(1,0,1) + global_position * Vector3.UP, Vector3.UP)
				if anim_player and is_instance_valid(anim_player) and anim_player.current_animation != "shoot":
					anim_player.play("shoot")
					await anim_player.animation_finished
				else:
					return
				if player_is_in_shoot_area:
					start_reposition()
				elif player_is_in_walk_area:
					state = BANANA_STATE.WALK
				else:
					state = BANANA_STATE.IDLE
			else:
				state = BANANA_STATE.WALK
			velocity = Vector3.ZERO
		BANANA_STATE.WALK:
			if can_see_player():
				if player_is_in_shoot_area:
					state = BANANA_STATE.SHOOT
				if anim_player and is_instance_valid(anim_player):
					anim_player.play("walk")
				look_at(player.global_position * Vector3(1,0,1) + global_position * Vector3.UP, Vector3.UP)
				velocity = ((player.global_position - global_position) * Vector3(1,0,1)).normalized() * FpsResourceManagerInstance.banana_speed
			else:
				if anim_player and is_instance_valid(anim_player):
					anim_player.play("idle")
				velocity = Vector3.ZERO
		BANANA_STATE.REPOSITION:
			if can_see_player():
				if global_position.distance_to(goal_pos) <= 1.2:
					state = BANANA_STATE.SHOOT
					return
				look_at(player.global_position * Vector3(1,0,1) + global_position * Vector3.UP, Vector3.UP)
				if anim_player and is_instance_valid(anim_player):
					anim_player.play("walk")
				velocity = ((goal_pos - global_position) * Vector3(1,0,1)).normalized() * FpsResourceManagerInstance.banana_speed
			else:
				if player_is_in_walk_area:
					state = BANANA_STATE.WALK
				else:
					state = BANANA_STATE.IDLE
		_:
			if anim_player and is_instance_valid(anim_player):
				anim_player.play("idle")
			velocity = Vector3.ZERO
	if not is_on_floor():
		velocity.y -= 1000 * delta
	move_and_slide()


func can_see_player() -> bool:
	player_ray.global_rotation = Vector3.ZERO
	player_ray.global_position = global_position + Vector3.UP
	player_ray.target_position = player.global_position - global_position

	if player_ray.is_colliding():
		var _object = player_ray.get_collider()
		if _object and (_object.is_in_group("PlayerHitbox") or _object.is_in_group("Player")):
			return true
	return false


func damage() -> void:
	_health -= FpsResourceManagerInstance.bullet_damage

	if not is_dead and _health <= 0:
		die()


func knife() -> void:
	_health -= FpsResourceManagerInstance.knife_damage

	if not is_dead and _health <= 0:
		die()


func die() -> void:
	is_dead = true
	model.queue_free()
	collision.queue_free()
	var ammo = ammonition.instantiate()
	ammo.set_deferred("global_position", global_position)
	get_tree().root.get_node("Fps").add_child(ammo)
	particles.emitting = true
	$CPUParticles3D2/DeathSFX.play()
	await particles.finished
	queue_free()


func _on_shoot_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = true
		state = BANANA_STATE.SHOOT
		if not player:
			player = area.get_parent()


func _on_shoot_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = false


func _on_walk_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = true
		state = BANANA_STATE.WALK
		if not player:
			player = area.get_parent()


func _on_walk_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = false
		state = BANANA_STATE.IDLE


func start_reposition() -> void:
	walk_rays.shuffle()
	for ray in walk_rays:
		if ray.get_collider() == null:
			dummy_node.get_parent().remove_child(dummy_node)
			ray.add_child(dummy_node)
			dummy_node.position = ray.target_position
			goal_pos = dummy_node.global_position + (ray.global_position - dummy_node.global_position).normalized() * 0.5
			state = BANANA_STATE.REPOSITION
			return


func shoot() -> void:
	var _bullet = bullet.instantiate() as FpsBananaBullet
	_bullet.set_deferred("global_position", barrel.global_position)
	_bullet.set_deferred("player", player)
	get_parent().add_child(_bullet)
