extends Node3D

### EXPORT VARIABLE REFERENCES
@export var obstacles : Array [PackedScene]
@export var collectable : PackedScene

###### OBSTACLE SETTINGS
@export_range(0,100) var obstacles_spawing_chance : int  = 0
###### COLLECTABLE SETTINGS
@export_range(0,100) var collectable_spawning_chance : int =0

var lastspawn = 0   ### 0 = obstacle / 1 = collectable
var defined_obstacle : PackedScene
const LINE_SIZE = 18
##### DEBUG 
var county_obstacles :int = 0
var county_collectable : int  = 0
var county_left : int = 0
func _ready():
	defined_obstacle = obstacles.pick_random()
	spawning_objects()

	##### END OUTPUT
	print ( "collectables:",county_collectable)
	print (" obstacles : ", county_obstacles)
	print (" no objects spawned : ", county_left)

func spawning_objects():
	for i in self.get_children ():
		if randi_range(0,100) < obstacles_spawing_chance:
			spawn_obstacle(i)
		elif randi_range(0,100) < collectable_spawning_chance:
			spawn_collectable(i)
		else:
			county_left +=1

func spawn_obstacle ( _i : Node3D):
	var _instance = defined_obstacle.instantiate()
	_i.add_child(_instance)
	_instance.global_position = _i.global_position
	print("obstacle spawned")
	county_obstacles += 1

func spawn_collectable(_i: Node3D):
	var _instance = collectable.instantiate()
	_i.add_child(_instance)
	_instance.global_position = _i.global_position
	print ("collectable spawned")
	county_collectable += 1