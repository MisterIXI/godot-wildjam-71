class_name FpsBanana
extends CharacterBody3D

@export var _health : int = 100
@export var shoot_area : Area3D = null
@export var walk_area : Area3D = null
@export var walk_directions : int = 4

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
		ray.enabled = true
		ray.name = "walk_ray_ " + str(i)
		walk_rays.append(ray)

func damage() -> void:
	_health -= FpsResourceManagerInstance.bullet_damage

	if _health <= 0:
		die()

func die() -> void:
	queue_free()

func _on_shoot_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = true

func _on_shoot_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_shoot_area = false

func _on_walk_area_entered(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = true

func _on_walk_area_exited(area : Area3D) -> void:
	if area.is_in_group("PlayerHitbox"):
		player_is_in_walk_area = false
