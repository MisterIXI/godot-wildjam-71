extends Node
##### VARIABLE PRELOAD SCENES
const module_01 = "res://scenes/game_mode_2_driving/modules/driving_module_01.tscn"
const module_02 = "res://scenes/game_mode_2_driving/modules/driving_module_01_B.tscn"
const module_03= "res://scenes/game_mode_2_driving/modules/driving_module_01_C.tscn"
const module_04= "res://scenes/game_mode_2_driving/modules/driving_module_01_D.tscn"
const module_05="res://scenes/game_mode_2_driving/modules/driving_module_02.tscn"
const module_06= "res://scenes/game_mode_2_driving/modules/driving_module_03.tscn"
const module_07= "res://scenes/game_mode_2_driving/modules/driving_module_04.tscn"
const module_08 = "res://scenes/game_mode_2_driving/modules/driving_module_05.tscn"
const module_09 = "res://scenes/game_mode_2_driving/modules/driving_module_06.tscn"
const module_10 = "res://scenes/game_mode_2_driving/modules/driving_module_07.tscn"
const module_11 = "res://scenes/game_mode_2_driving/modules/driving_module_08.tscn"
################ spawn_ instance ####################
var spawn_module_01
var spawn_module_02
var spawn_module_03
var spawn_module_04
var spawn_module_05
var spawn_module_06
var spawn_module_07
var spawn_module_08
var spawn_module_09
var spawn_module_10
var spawn_module_11
#### GARAGE
const module_garage ="res://assets/models/fps/fps_map_car_version2.tscn"
var spawn_garage

# var win_garage_object = pre_driving_module_garage.instantiate()
var container_alive = []

func _ready():
	### LOAD SCENE IN EXTRA THREAD
	ResourceLoader.load_threaded_request(module_01)
	ResourceLoader.load_threaded_request(module_02)
	ResourceLoader.load_threaded_request(module_03)
	ResourceLoader.load_threaded_request(module_04)
	ResourceLoader.load_threaded_request(module_05)
	ResourceLoader.load_threaded_request(module_06)
	ResourceLoader.load_threaded_request(module_07)
	ResourceLoader.load_threaded_request(module_08)
	ResourceLoader.load_threaded_request(module_09)
	ResourceLoader.load_threaded_request(module_10)
	ResourceLoader.load_threaded_request(module_11)
	## LOAD GARAGE SCENE IN EXTRA THREAD
	ResourceLoader.load_threaded_request(module_garage)
	## DEFINE 
	spawn_module_01 = ResourceLoader.load_threaded_get(module_01)
	spawn_module_02 = ResourceLoader.load_threaded_get(module_02)
	spawn_module_03 = ResourceLoader.load_threaded_get(module_03)
	spawn_module_04 = ResourceLoader.load_threaded_get(module_04)
	spawn_module_05 = ResourceLoader.load_threaded_get(module_05)
	spawn_module_06 = ResourceLoader.load_threaded_get(module_06)
	spawn_module_07 = ResourceLoader.load_threaded_get(module_07)
	spawn_module_08 = ResourceLoader.load_threaded_get(module_08)
	spawn_module_09 = ResourceLoader.load_threaded_get(module_09)
	spawn_module_10 = ResourceLoader.load_threaded_get(module_10)
	spawn_module_11 = ResourceLoader.load_threaded_get(module_11)

	spawn_garage = ResourceLoader.load_threaded_get(module_garage)
	### Random module container
	container_alive = [spawn_module_01,spawn_module_02,spawn_module_03, spawn_module_04,spawn_module_01,spawn_module_02,spawn_module_03, spawn_module_04,
	spawn_module_01,spawn_module_02,spawn_module_03, spawn_module_04,
	spawn_module_01,spawn_module_02,spawn_module_03, spawn_module_04, spawn_module_05, spawn_module_06,
	spawn_module_07, spawn_module_08, spawn_module_09, spawn_module_10, spawn_module_11]

func get_random_module():
	return container_alive.pick_random()
func get_garage_object():
	return spawn_garage
