extends Resource
class_name DrivingStage
# VARIABLE MODULES  ENVIROMENT
@export var modules_array : Array[PackedScene] = []

# VARIABLE OBJECTS OBSTACLES
@export var obstacle : PackedScene


# VARIABLE OBJECTS COLLECTABLE
@export var collectable :PackedScene

# VARIABLE SNAKE SPEED - higher is harder
@export var snakeSpeed :float = 1
@export var win_condition_collectables : int = 50
@export var max_health : int = 5
@export var difficult_string = "EASY MODE"