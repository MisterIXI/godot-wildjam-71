extends Node

##### VARIABLE PRELOAD SCENES
var pre_driving_module_01 = load("res://scenes/game_mode_2_driving/modules/driving_module_01.tscn")
var pre_driving_module_02 = load("res://scenes/game_mode_2_driving/modules/driving_module_01_B.tscn")
var pre_driving_module_03 = load("res://scenes/game_mode_2_driving/modules/driving_module_01_C.tscn")
var pre_driving_module_04 = load("res://scenes/game_mode_2_driving/modules/driving_module_01_D.tscn")
var pre_driving_module_05 = load("res://scenes/game_mode_2_driving/modules/driving_module_02.tscn")
var pre_driving_module_06 = load("res://scenes/game_mode_2_driving/modules/driving_module_03.tscn")
var pre_driving_module_07 = load("res://scenes/game_mode_2_driving/modules/driving_module_04.tscn")
var pre_driving_module_08 = load("res://scenes/game_mode_2_driving/modules/driving_module_05.tscn")
var pre_driving_module_09 = load("res://scenes/game_mode_2_driving/modules/driving_module_06.tscn")
var pre_driving_module_10 = load("res://scenes/game_mode_2_driving/modules/driving_module_07.tscn")
var pre_driving_module_11 = load("res://scenes/game_mode_2_driving/modules/driving_module_08.tscn")

#### GARAGE
var pre_driving_module_garage = load("res://scenes/game_mode_2_driving/garage/fps_map_car_version.tscn")
# var win_garage_object = pre_driving_module_garage.instantiate()

var container_alive = []

func _ready():
	### Module 01
	var _module_01 = pre_driving_module_01.instance()
	container_alive.append(_module_01)
### Module 02
	var _module_02 = pre_driving_module_02.instance()
	container_alive.append(_module_02)
### Module 03
	var _module_03 = pre_driving_module_03.instance()
	container_alive.append(_module_03)
### Module 04
	var _module_04 = pre_driving_module_04.instance()
	container_alive.append(_module_04)
### Module 05
	var module_05 = pre_driving_module_05.instance()
	container_alive.append(module_05)
### Module 06
	var module_06 = pre_driving_module_06.instance()
	container_alive.append(module_06)
### Module 07
	var module_07 = pre_driving_module_07.instance()
	container_alive.append(module_07)
### Module 08
	var module_08 = pre_driving_module_08.instance()
	container_alive.append(module_08)
### Module 09
	var module_09 = pre_driving_module_09.instance()
	container_alive.append(module_09)
### Module 10
	var module_10 = pre_driving_module_10.instance()
	container_alive.append(module_10)
### Module 11
	var module_11 = pre_driving_module_11.instance()
	container_alive.append(module_11)

func get_random_module():
	return container_alive.pick_random()

func get_garage_object():
	return pre_driving_module_garage.instance()