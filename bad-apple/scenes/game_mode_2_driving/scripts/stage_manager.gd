extends Node

# variable queue for better performance
var spawn_queue = []
# Random 
var rng = RandomNumberGenerator.new()
# VARIABLE OFFSET  = CURRENT LENGTH
var offset = 0
# VARIABLE  CONST MODULE SIZE & SPAWNING TIME 
const BASE_MODULE_SIZE : int = 36
const BASE_DELETE_BUFFER : int  = 24
const BASE_SPAWNING_RAD : int  =36
# VARIABLE IS GAME RUNNING
var is_gamemode_running = false
# VARIABLE SET STAGE MOTHER
var stage_object_holder  = null

# VARIABLE CURRENT_ DIFFICULT
var current_stage_difficult : DrivingStage = null
# VARIABLE CURRENT SNAKESPEED
var current_snake_speed : float  = 1
# VARIABLE CURRENT CHECKPOINTS
var current_checkpoints = 0

# VARIABLE HEALTH
var current_health  = 3
var player_node : Node3D = null
var player_node_offset : float =  -176.574
# VARIABLE UI_CONTROLLER
var ui_controller : UI_Controller  =null
################################################## SIGNALS ##################################
signal next_chunk
signal driving_gamemode_start(stage : Node3D, difficult : DrivingStage)
signal player_hit

func _ready():
	next_chunk.connect(on_next_chunk)
	driving_gamemode_start.connect(on_gamemode_start)
	# ui_controller.update_collectable(str(current_stage_difficult.win_condition_collectables))

################### MAIN LOOP ####################
func _process(_delta):

	if player_node.global_position.x  > player_node_offset + BASE_SPAWNING_RAD:
		player_node_offset = player_node.global_position.x
		on_next_chunk()

func set_player(_self: Node3D, _ui_c : UI_Controller):
	player_node = _self
	ui_controller =_ui_c
func spawn_modules():
	if !is_gamemode_running:
		return
	rng.randomize()
	
	var instance_Mother = current_stage_difficult.modules_array[rng.randi_range(0, current_stage_difficult.modules_array.size()-1)].instantiate()
	instance_Mother.position.x  =BASE_MODULE_SIZE * offset
	stage_object_holder.add_child(instance_Mother)
	spawn_queue.push_back(instance_Mother)
	#delete oldest
	if spawn_queue.size() > BASE_DELETE_BUFFER:
		spawn_queue[0].queue_free()
		spawn_queue.pop_front()

	offset += 1
### SIGNAL CREATE PLAYER DAMAGE
func on_player_get_hit():
	current_health -= 1
	if current_health <= 0:
		print ("GAME OVER")
	player_hit.emit()
### SIGNAL CREATE NEW CHUNK
func on_next_chunk():
	if !is_gamemode_running:
		return

	spawn_modules()

func on_gamemode_start(stage, difficult):
	print ("game started")
	# DEFINE NEW STAGE OBJECT HOLDER AND START GAMEMODE
	stage_object_holder = stage
	current_stage_difficult = difficult
	current_snake_speed = current_stage_difficult.snakeSpeed
	is_gamemode_running = true
	
func on_restart():
	# RESET ALL VARIABLES AND POSITIONS
	offset = 0
	# PlayerPosition reset 0
	
	for x in spawn_queue:
		x.queue_free()

func get_rnd_weighted_object(type: int):
	rng.randomize()

	match type:
		0:#modules
			return rng.randi_range(0, current_stage_difficult.modules_array.size()-1)
		1:
		#obstacles
			return rng.randi_range(0, current_stage_difficult.obstacle_array.size()-1)
		2:
		#collectable
			return rng.randi_range(0, current_stage_difficult.collectable_array.size()-1)

		_: #default
			print("default")
			return rng.randi_range(0, current_stage_difficult.modules_array.size()-1)

func add_coin_to_wallet():
	current_checkpoints -= 1
	## ADD coins
	ui_controller.update_collectable(str(current_stage_difficult.win_condition_collectables - current_checkpoints))
	
	if current_checkpoints >= current_stage_difficult.win_condition_obstacles_cleared:
		print(" YOU WON THE GAME IN " + current_stage_difficult.difficult_string)