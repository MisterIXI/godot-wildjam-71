extends PathFollow3D
class_name SnakePathFollower

@export var settings: SnakeSettings
@onready var parent_curve: Path3D = get_parent()
@export var snake_part: PathSnakePart
@export var spawn_with_parts: int = 5
@export var self_scene: PackedScene
@export var is_menu_snake: bool = false

var back_part: SnakePathFollower = null
var is_follower = false
var snake_parts: Array[SnakePathFollower] = []
var baked_length: float = 0
var next_body_part: SnakePathFollower = null
func _ready():
	if is_follower:
		return
	progress = settings.grid_tile_size * (spawn_with_parts - 1)
	# BROTHER WHAT THE HELL
	# TODO: why is snake_part here the second part of the snake? Why is the else part here the head of the snake????
	snake_part.switch_to_body()
	snake_part.play_animation("idle")
	snake_part.switch_to_head()
	var i = spawn_with_parts - 1
	var prev_part: SnakePathFollower = null
	while i > 0:
		i -= 1
		var dup = self_scene.instantiate()
		# var dup = duplicate()
		assert(dup != self)
		dup.is_follower = true
		parent_curve.add_child.call_deferred(dup)
		dup.progress = i * settings.grid_tile_size
		snake_parts.append(dup)
		if i == spawn_with_parts - 2:
			next_body_part = dup
		else:
			prev_part.next_body_part = dup
		prev_part = dup
		if i > 0:
			dup.snake_part.switch_to_body()
			# dup.snake_part.switch_to_head()
		else:
			dup.snake_part.switch_to_head()
			# dup.snake_part.switch_to_tail()
	baked_length = parent_curve.curve.get_baked_length()
	# progress += 2
	_connect_spawned_hurtbox_parts()
	if not is_menu_snake:
		var delay_tail = func():
			get_parent().get_child(-1).get_child(0).switch_to_tail()
		delay_tail.call_deferred()
	else:
		var delay_tail = func():
			get_parent().get_child(-1).get_child(0).switch_to_body()
		delay_tail.call_deferred()
	
	
func finish_path():
	snake_part.play_animation("hurt")
	is_follower = true
	for i in range(snake_parts.size()):
		snake_parts[i].progress = progress - (i + 1) * settings.grid_tile_size

func _physics_process(delta):
	if is_follower:
		return
	var change = delta * settings.base_speed * settings.grid_tile_size
	progress += change
	if not loop and progress_ratio >= 1:
		finish_path()
		is_follower = true
	else:
		for snake in snake_parts:
			snake.progress += change

func update_follower_progress():
	for i in range(snake_parts.size()):
		
		# snake_parts[i].progress = parent_curve.curve.get_closest_offset(snake_parts[i].global_position)
		snake_parts[i].progress = progress - (i + 1) 
		

func _connect_spawned_hurtbox_parts():
	if is_follower:
		return
	for i in range(snake_parts.size()):
		snake_parts[i].get_child(0).area_entered.connect(_on_part_hurtbox_entered.bind(i))

func delete_last_part():
	if snake_parts.size() > 0:
		snake_parts[-1].queue_free()
		snake_parts.pop_back()
		snake_parts[-1].next_body_part = null
		
signal snake_hurt_by_bullet(area3d)
signal player_was_eaten()

func _on_part_hurtbox_entered(area: Area3D, id: int):
	if is_follower:
		return
	if area.is_in_group("Player"):
		player_was_eaten.emit()
		return
	if area.is_in_group("Bullet"):
		if id + 1 == snake_parts.size():
			snake_hurt_by_bullet.emit(area)
		else:
			area.queue_free()