class_name FpsTestKeybinds
extends Node


func _input(_event):
	if Input.is_action_just_pressed("f"):
		FpsResourceManagerInstance.change_resource("health", -10)
