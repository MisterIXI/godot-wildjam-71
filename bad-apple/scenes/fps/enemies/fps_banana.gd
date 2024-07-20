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

var player : Node3D = null
var state : BANANA_STATE = BANANA_STATE.IDLE
var goal_pos : Vector3 = Vector3.ZERO

var player_is_in_shoot_area : bool = false
var player_ray : RayCast3D = null

var player_is_in_walk_area : bool = false
var walk_rays = []

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
		ray.target_position = Vector3.RIGHT.rotated(Vector3.UP, deg_to_rad(i * 360.0 / walk_directions)) * FpsResourceManagerInstance.banana_reposition_distance + Vector3 (0.5,0,0.5)
		ray.name = "walk_ray_" + str(i * 360.0 / walk_directions)
		ray.enabled = true
		walk_rays.append(ray)


func _physics_process(delta):
	match state:
		BANANA_STATE.SHOOT:
			if can_see_player():
				look_at(player.global_position, Vector3.UP)
				if anim_player:
					anim_player.play("shoot")
					await anim_player.animation_finished
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
				if anim_player:
					anim_player.play("walk")
				look_at(player.global_position, Vector3.UP)
				velocity = ((player.global_position - global_position) * Vector3(1,0,1)).normalized() * FpsResourceManagerInstance.banana_speed
			else:
				if anim_player:
					anim_player.play("idle")
				velocity = Vector3.ZERO
		BANANA_STATE.REPOSITION:
			if can_see_player():
				if global_position.distance_to(goal_pos) <= 1.2:
					state = BANANA_STATE.SHOOT
					return
				look_at(player.global_position, Vector3.UP)
				if anim_player:
					anim_player.play("walk")
				velocity = ((goal_pos - global_position) * Vector3(1,0,1)).normalized() * FpsResourceManagerInstance.banana_speed
			else:
				if player_is_in_walk_area:
					state = BANANA_STATE.WALK
				else:
					state = BANANA_STATE.IDLE
		_:
			if anim_player:
				anim_player.play("idle")
			velocity = Vector3.ZERO

	if not is_on_floor():
		velocity.y -= 15 * delta
	move_and_slide()


func can_see_player() -> bool:
	player_ray.global_rotation = Vector3.ZERO
	player_ray.global_position = global_position + Vector3.UP
	player_ray.target_position = player.global_position - global_position

	if player_ray.is_colliding():
		var _object = player_ray.get_collider()
		if _object.is_in_group("PlayerHitbox") or _object.is_in_group("Player"):
			return true
	return false


func damage() -> void:
	_health -= FpsResourceManagerInstance.bullet_damage

	if _health <= 0:
		die()


func die() -> void:
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
		print(ray.name)
		if ray.get_collider() == null:
			print("-------------")
			ray.global_rotation = Vector3.ZERO
			goal_pos = ray.global_position + ray.target_position - Vector3(0.5,0,0.5)
			state = BANANA_STATE.REPOSITION
			return
	await get_tree().create_timer(2, false).timeout
	if player_is_in_shoot_area:
		state = BANANA_STATE.SHOOT
	elif player_is_in_walk_area:
		state = BANANA_STATE.WALK
	else:
		state = BANANA_STATE.IDLE
