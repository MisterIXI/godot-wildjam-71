class_name FpsBanana
extends CharacterBody3D

@export var _health : int = 100
@export var shoot_area : Area3D = null
@export var walk_area : Area3D = null
@export var walk_directions : int = 4

var player : Node3D = null

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
	player_ray.enabled = false
	player_ray.name = "player_ray"

	var _distance = walk_area.get_child(0).shape.radius / 2
	for i in walk_directions:
		var ray = RayCast3D.new()
		add_child(ray)
		ray.position = Vector3(0, 1, 0)
		ray.target_position = Vector3.RIGHT.rotated(Vector3.UP, deg_to_rad(i * 360.0 / walk_directions)) * _distance
		ray.enabled = false
		ray.name = "walk_ray_" + str(i)
		walk_rays.append(ray)


func _physics_process(_delta):
	if player_is_in_shoot_area:
		player_ray.enabled = true
		player_ray.global_rotation = Vector3.ZERO
		player_ray.target_position = player.global_position - player_ray.global_position + Vector3.UP

		if player_ray.is_colliding():
			var _object = player_ray.get_collider()
			if _object.is_in_group("PlayerHitbox") or _object.is_in_group("Player"):
				look_at(player.global_position, Vector3.UP)


func damage() -> void:
	_health -= FpsResourceManagerInstance.bullet_damage

	if _health <= 0:
		die()


func die() -> void:
	queue_free()


func _on_shoot_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = true

		if not player:
			player = area.get_parent()


func _on_shoot_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = false


func _on_walk_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = true

		if not player:
			player = area.get_parent()


func _on_walk_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = false
