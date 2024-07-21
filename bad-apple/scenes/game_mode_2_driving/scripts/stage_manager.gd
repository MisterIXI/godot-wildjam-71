extends Node
class_name Stage_Manager
# variable queue for better performance
var spawn_queue = []
# Random 
var rng = RandomNumberGenerator.new()
static var instance : Stage_Manager = null
# VARIABLE OFFSET  = CURRENT LENGTH
var offset = 0
# VARIABLE  CONST MODULE SIZE & SPAWNING TIME 
const BASE_MODULE_SIZE : int = 36
const BASE_DELETE_BUFFER : int  = 24
const BASE_SPAWNING_RAD : int  =36
# VARIABLE IS GAME RUNNING
var is_gamemode_running = false


# VARIABLE CURRENT SNAKESPEED
var current_snake_speed : float  = 1
# VARIABLE CURRENT CHECKPOINTS
var current_checkpoints = 0

var player_node_offset : float =  -176.574
# VARIABLE HEALTH
var current_health  = 5
### VARIABLE EXPORTS 
@export var stage_object_holder : Node3D
@export var current_stage_difficult : DrivingStage
@export var player_node : Node3D
# VARIABLE UI_CONTROLLER
@export var ui_controller : UI_Controller
################################################## SIGNALS ##################################
signal next_chunk
signal driving_gamemode_start(stage : Node3D, difficult : DrivingStage)
signal player_hit
signal get_collectable

func _ready():
    #print("START DIFFICULT : ",current_stage_difficult.difficult_string)
    on_restart()
    next_chunk.connect(on_next_chunk)
    
    ui_controller.update_collectable(str(current_stage_difficult.win_condition_collectables))
    ui_controller.update_life(current_health)
    is_gamemode_running = true
    current_snake_speed = current_stage_difficult.snakeSpeed
    get_collectable.connect(on_collected_coin)
    if instance == null:
        instance = self
    else:
        return


################### MAIN LOOP ####################
func _process(_delta):
    if !is_gamemode_running :
        return
    if player_node.global_position.x  > player_node_offset + BASE_SPAWNING_RAD:
        player_node_offset = player_node.global_position.x
        on_next_chunk()

func spawn_modules():
    if !is_gamemode_running:
        return
    rng.randomize()
    var instance_Mother = current_stage_difficult.modules_array[rng.randi_range(0, current_stage_difficult.modules_array.size()-1)].instantiate()
    instance_Mother.position.x  = BASE_MODULE_SIZE * offset
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
    ### SET UI 
    ui_controller.update_life(current_health)
    if current_health <= 0:
        print ("GAME OVER")
    player_hit.emit()
### SIGNAL CREATE NEW CHUNK
func on_next_chunk():
    if !is_gamemode_running:
        return

    spawn_modules()

func on_restart():
    # RESET ALL VARIABLES AND POSITIONS
    offset = 0
    current_health = current_stage_difficult.max_health
    current_checkpoints = 0
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

func on_collected_coin():
    current_checkpoints += 1
    var _text :String = " %d / %d" %[current_checkpoints,current_stage_difficult.win_condition_collectables]
    ui_controller.update_collectable(_text)
    
    if current_checkpoints >= current_stage_difficult.win_condition_collectables:
        print(" YOU WON THE GAME IN " + current_stage_difficult.difficult_string)