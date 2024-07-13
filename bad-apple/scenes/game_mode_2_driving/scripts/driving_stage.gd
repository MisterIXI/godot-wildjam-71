extends Resource
class_name DrivingStage
# VARIABLE MODULES  ENVIROMENT
@export var modules_array : Array[PackedScene] = []

# VARIABLE OBJECTS OBSTACLES
@export var obstacle_array : Array[PackedScene] = []


# VARIABLE OBJECTS COLLECTABLE
@export var collectable_array :Array[PackedScene] = []

# VARIABLE SNAKE SPEED - higher is harder
@export var snakeSpeed :float = 1
@export var win_condition_obstacles_cleared : int = 50
@export var difficult_string = "EASY MODE"