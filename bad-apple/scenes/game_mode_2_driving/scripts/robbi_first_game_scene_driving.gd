extends Node3D

@export var stage_object : Node3D
@export var difficult : DrivingStage
func _ready():
	Driving_Stage_Manager.driving_gamemode_start.emit(stage_object, difficult)