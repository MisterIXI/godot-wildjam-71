extends Node
class_name Stage_Manager

static var instance : Stage_Manager = null
# VARIABLE OFFSET  = CURRENT LENGTH
var offset = 0
# VARIABLE  CONST MODULE SIZE & SPAWNING TIME 
const BASE_MODULE_SIZE : int = 36
const BASE_DELETE_BUFFER : int  = 24
const BASE_SPAWNING_RAD : int  =36
# VARIABLE IS GAME RUNNING
var is_gamemode_running = false

# variable queue for better performance
var spawn_queue = []
# VARIABLE CURRENT SNAKESPEED
var current_snake_speed : float  = 1
# VARIABLE CURRENT CHECKPOINTS
var current_checkpoints = 0

var player_node_offset : float =  -176.574
# VARIABLE HEALTH
var current_health  = 5
## Variable mission coins need to win
const player_collectable_needed : int = 50
### VARIABLE EXPORTS 
@export var stage_object_holder : Node3D

@export var player_node : Node3D
# VARIABLE UI_CONTROLLER
@export var ui_controller : UI_Controller

@export var win_garage_transition_effect: Node3D

################################################## SIGNALS ##################################
signal next_chunk
signal driving_gamemode_start(stage : Node3D, difficult : DrivingStage)
signal player_hit
signal get_collectable

func _ready():

    on_restart()
    next_chunk.connect(on_next_chunk)
    
    var _text :String = " %d / %d" %[current_checkpoints, player_collectable_needed]
    ui_controller.update_collectable(_text)
    ui_controller.update_life(current_health)
    is_gamemode_running = true
    current_snake_speed = 1
    get_collectable.connect(on_collected_coin)
    if instance == null:
        instance = self
    else:
        return
    spawn_modules()
    spawn_modules()

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
    # rng.randomize()
   
    var instance_module = ScenePreloader.get_random_module().instantiate()
    instance_module.position.x  = BASE_MODULE_SIZE * offset
    stage_object_holder.add_child(instance_module)
    offset += 1
    spawn_queue.push_back(instance_module)
    #delete oldest
    if spawn_queue.size() > BASE_DELETE_BUFFER:
        spawn_queue[0].queue_free()
        spawn_queue.pop_front()

### SIGNAL CREATE PLAYER DAMAGE
func on_player_get_hit():
    current_health -= 1
    ### SET UI 
    ui_controller.update_life(current_health)
    if current_health <= 0:
        print ("GAME OVER")
        #### GAME OVER ####
        ui_controller.on_player_died()
    player_hit.emit()
### SIGNAL CREATE NEW CHUNK
func on_next_chunk():
    if !is_gamemode_running:
        return

    spawn_modules()

func on_restart():
    # RESET ALL VARIABLES AND POSITIONS
    offset = 0
    current_health = 3
    current_checkpoints = 0
    # PlayerPosition reset 0
    get_tree().paused = false

func on_collected_coin():
    current_checkpoints += 1
    var _text :String = " %d / %d" %[current_checkpoints,player_collectable_needed]
    ui_controller.update_collectable(_text)
    ### IF GAME FINISHED
    if current_checkpoints >= player_collectable_needed:
        #print(" YOU WON THE GAME IN " + current_stage_difficult.difficult_string)
        var _instance = ScenePreloader.get_garage_object().instantiate()
        _instance.position.x  = BASE_MODULE_SIZE * offset
        stage_object_holder.add_child(_instance)
        end_driving_game()

func end_driving_game():
        is_gamemode_running = false
        ui_controller.visible = false
        win_garage_transition_effect.visible = true
