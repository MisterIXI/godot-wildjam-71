extends Path3D
class_name  SnakeBossPathMaker

const MIN_X = -8.3
const MAX_X = 7.5
const MIN_Z = -8.75
const MAX_Z = 8.3
const DOWN_LEFT = Vector3(MIN_X, 0, MAX_Z)
const DOWN_RIGHT = Vector3(MAX_X, 0, MAX_Z)
const UP_RIGHT = Vector3(MAX_X, 0, MIN_Z)
const UP_LEFT = Vector3(MIN_X, 0, MIN_Z)

enum STATE{
	HUNT,
	ATTACK,
	RESET_1,
	RESET_2,
}
var phase: int = 1
var state: STATE = STATE.HUNT
var old_state: STATE = STATE.HUNT
@export var player: CharacterBody3D
@export var snake_head: SnakePathFollower

@export var snake_hurt_box: Area3D
@export var snake_part_kill_particle: CPUParticles3D

func _ready():
	curve.set_point_position(1, UP_LEFT)
	curve.set_point_position(2, DOWN_LEFT)
	curve.set_point_position(3, DOWN_RIGHT)
	curve.set_point_position(4, UP_RIGHT)

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
			elif  abs(player.global_position.x - snake_head.global_position.x) < 0.5:
				print("GOTCHA")
				var new_up = snake_head.position + Vector3.LEFT * 0.3
				var new_down = new_up
				new_down.z = MAX_Z
				curve.set_point_position(1, new_up)
				curve.set_point_position(2, new_down)
				state = STATE.ATTACK
			pass
		STATE.ATTACK:
			# move down until at point, next down right corner
			if _is_at_next_point():
				curve.set_point_position(3, DOWN_RIGHT)
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
	pass

func _phase_3_step():
	pass

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