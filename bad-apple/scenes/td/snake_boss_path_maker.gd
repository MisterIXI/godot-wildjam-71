extends Path3D
class_name SnakeBossPathMaker

const MIN_X = -8.3
const MAX_X = 7.5
const MIN_Z = -8.75
const MAX_Z = 8.3
const DOWN_LEFT = Vector3(MIN_X, 0, MAX_Z)
const DOWN_RIGHT = Vector3(MAX_X, 0, MAX_Z)
const UP_RIGHT = Vector3(MAX_X, 0, MIN_Z)
const UP_LEFT = Vector3(MIN_X, 0, MIN_Z)

enum STATE {
	HUNT,
	ATTACK,
	RESET_1,
	RESET_2,
}
var phase: int = 1
var state: STATE = STATE.HUNT
var old_state: STATE = STATE.HUNT
@export var player: TDCharacter
@export var snake_head: SnakePathFollower

@export var hud: TDHUD

@export var snake_part_kill_particle: CPUParticles3D
@export var final_scene: PackedScene

const HP_PER_PART: float = 100
const DMG_PER_BULLET: float = 5
var part_hp: float = HP_PER_PART

func _ready():
	curve.set_point_position(1, UP_LEFT)
	curve.set_point_position(2, DOWN_LEFT)
	curve.set_point_position(3, DOWN_RIGHT)
	curve.set_point_position(4, UP_RIGHT)
	snake_head.snake_hurt_by_bullet.connect(_on_snake_hurt_box_area_entered)
	snake_head.player_was_eaten.connect(_on_player_was_eaten)
	snake_head.settings.base_speed = 8

func _physics_process(_delta):
	if state != old_state:
		print("STATE: ", state)
		old_state = state
	match phase:
		1:
			_phase_1_step()
		2:
			_phase_2_step()
		3:
			_phase_3_step()

func _phase_1_step():
	match state:
		STATE.HUNT:
			# move until you see player and set next point at player x and move down
			# fallback when missing player
			if snake_head.global_position.x > MAX_X - 1:
				return
			if _is_at_next_point():
				curve.set_point_position(2, DOWN_LEFT)
				state = STATE.ATTACK
			elif abs(player.global_position.x - snake_head.global_position.x) < 0.5:
				print("GOTCHA")
				var new_up = snake_head.position + Vector3.LEFT * 0.3
				var new_down = new_up
				new_down.z = MAX_Z
				curve.set_point_position(1, new_up)
				curve.set_point_position(2, new_down)
				snake_head.update_follower_progress()
				state = STATE.ATTACK
			pass
		STATE.ATTACK:
			# move down until at point, next down right corner
			if _is_at_next_point():
				curve.set_point_position(3, DOWN_RIGHT)
				snake_head.update_follower_progress()
				state = STATE.RESET_1
			pass
		STATE.RESET_1:
			# move to down right corner, next to up right corner
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(4, UP_RIGHT)
				curve.set_point_position(0, UP_RIGHT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.RESET_2
			pass
		STATE.RESET_2:
			# move to up right corner, next set to up left corner for attack
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(1, UP_LEFT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.HUNT
			pass
	pass

func _phase_2_step():
	match state:
		STATE.HUNT:
			# move until you see player and set next point at player x and move down
			# fallback when missing player
			if snake_head.global_position.x > MAX_X - 1:
				return
			if _is_at_next_point():
				curve.set_point_position(2, DOWN_LEFT)
				state = STATE.ATTACK
			elif abs(player.global_position.x - snake_head.global_position.x) < 0.5:
				print("GOTCHA")
				var new_up = snake_head.position + Vector3.LEFT * 0.3
				var new_down = new_up
				new_down.z = MAX_Z
				curve.set_point_position(1, new_up)
				curve.set_point_position(2, new_down)
				snake_head.update_follower_progress()
				state = STATE.ATTACK
			pass
		STATE.ATTACK:
			# move down until at point, next down right corner
			if _is_at_next_point():
				curve.set_point_position(3, DOWN_RIGHT)
				snake_head.update_follower_progress()
				state = STATE.RESET_1
			pass
		STATE.RESET_1:
			# move to down right corner, next to up right corner
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(4, UP_RIGHT)
				curve.set_point_position(0, UP_RIGHT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.RESET_2
			pass
		STATE.RESET_2:
			# move to up right corner, next set to up left corner for attack
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(1, UP_LEFT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.HUNT
			pass
	pass

func _phase_3_step():
	match state:
		STATE.HUNT:
			# move until you see player and set next point at player x and move down
			# fallback when missing player
			if snake_head.global_position.x > MAX_X - 1:
				return
			if _is_at_next_point():
				curve.set_point_position(2, DOWN_LEFT)
				state = STATE.ATTACK
			elif abs(player.global_position.x - snake_head.global_position.x) < 0.5:
				print("GOTCHA")
				var new_up = snake_head.position + Vector3.LEFT * 0.3
				var new_down = new_up
				new_down.z = MAX_Z
				curve.set_point_position(1, new_up)
				curve.set_point_position(2, new_down)
				snake_head.update_follower_progress()
				state = STATE.ATTACK
			pass
		STATE.ATTACK:
			# move down until at point, next down right corner
			if _is_at_next_point():
				curve.set_point_position(3, DOWN_RIGHT)
				snake_head.update_follower_progress()
				state = STATE.RESET_1
			pass
		STATE.RESET_1:
			# move to down right corner, next to up right corner
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(4, UP_RIGHT)
				curve.set_point_position(0, UP_RIGHT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.RESET_2
			pass
		STATE.RESET_2:
			# move to up right corner, next set to up left corner for attack
			if _is_at_next_point():
				var pos = snake_head.position
				curve.set_point_position(1, UP_LEFT)
				snake_head.progress = curve.get_closest_offset(pos)
				snake_head.update_follower_progress()
				state = STATE.HUNT
			pass
	pass

func _relative_player_pos() -> Vector3:
	return player.global_position * 0.5 + global_position

func _is_at_next_point():
	var eps = 0.2
	match state:
		STATE.HUNT:
			return snake_head.position.distance_to(curve.get_point_position(1)) < eps
		STATE.ATTACK:
			return snake_head.position.distance_to(curve.get_point_position(2)) < eps
		STATE.RESET_1:
			return snake_head.position.distance_to(curve.get_point_position(3)) < eps
		STATE.RESET_2:
			return snake_head.position.distance_to(curve.get_point_position(4)) < eps

func _took_damage(snake_part: PathSnakePart):
	hud.snake_damaged.emit((100 * (3 - phase) + part_hp) / 3)
	# TODO: Add damage visual feedback
	pass
func _on_player_was_eaten():
	hud.death_label.visible = true
	player.kill_player()
	pass
func _on_snake_hurt_box_area_entered(area: Area3D):
	if area.is_in_group("Bullet"):
		area.queue_free()
		part_hp = clamp(part_hp - DMG_PER_BULLET, 0, HP_PER_PART)
		_took_damage(snake_head.snake_parts[ - 1].snake_part)

		if part_hp <= 0:
			snake_head.is_follower = true
			snake_head.snake_part.play_animation("hurt")
			snake_part_kill_particle.global_position = snake_head.snake_parts[- 1].global_position
			snake_part_kill_particle.visible = true
			snake_part_kill_particle.emitting = true
			snake_head.delete_last_part()
			phase += 1
			if phase == 4:
				await get_tree().create_timer(1).timeout
				get_tree().change_scene_to_packed(final_scene)
				return
			await get_tree().create_timer(1.5).timeout
			snake_head.snake_part.play_animation("idle")
			if phase == 2:
				snake_head.settings.base_speed = 13
			if phase == 3:
				snake_head.settings.base_speed = 18
			snake_part_kill_particle.emitting = false
			snake_head.is_follower = false
			part_hp = HP_PER_PART
