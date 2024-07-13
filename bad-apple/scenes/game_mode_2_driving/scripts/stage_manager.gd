extends Node3D

# VARIABLE MODULES  ENVIROMENT
@export var modules_array : Array[PackedScene] = []
# VARIABLE OBJECTS OBSTACLES
@export var obstacle_array : Array[PackedScene] = []
# VARIABLE OBJECTS COLLECTABLE
@export var collectable_array :Array[PackedScene] = []
# variable queue for better performance
var spawn_queue = []
# Random 
var rng = RandomNumberGenerator.new()
# VARIABLE OFFSET  = CURRENT LENGTH
var offset = 0
# VARIABLE  CONST MODULE SIZE & SPAWNING TIME 
const BASE_MODULE_SIZE : int = 6
signal next_chunk

func _ready():
	next_chunk.connect(on_next_chunk)

func spawn_modules():
	rng.randomize()
	var num = rng.randi_range(0, modules_array.size()-1)
	var instance = modules_array[num].instantiate()
	instance.position.x  =BASE_MODULE_SIZE * offset
	add_child(instance)
	#add to queue
	spawn_queue.push_back(instance)
	#delete oldest
	spawn_queue.pop_front()

	offset += 1

### SIGNAL CREATE NEW CHUNK
func on_next_chunk():
	spawn_modules()

func on_restart():
	offset = 0
	# PlayerPosition reset 0
	
	for x in spawn_queue:
		x.queue_free()