extends Node
# variable queue for better performance
var spawn_queue = []
# Random 
var rng = RandomNumberGenerator.new()
# VARIABLE OFFSET  = CURRENT LENGTH
var offset = 0
# VARIABLE  CONST MODULE SIZE & SPAWNING TIME 
const BASE_MODULE_SIZE : int = 12
const BASE_DELETE_BUFFER : int  = 12
# VARIABLE IS GAME RUNNING
var is_gamemode_running = false
# VARIABLE SET STAGE MOTHER
var stage_object_holder  = null

# VARIABLE CURRENT_ DIFFICULT
var current_stage_difficult : DrivingStage = null
# VARIABLE CURRENT SNAKESPEED
var current_snake_speed : float  = 1
################################################## SIGNALS ##################################
signal next_chunk
signal driving_gamemode_start(stage : Node3D, difficult : DrivingStage)

func _ready():
	next_chunk.connect(on_next_chunk)
	driving_gamemode_start.connect(on_gamemode_start)
	

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