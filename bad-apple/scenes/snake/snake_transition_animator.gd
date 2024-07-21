extends Node3D
class_name SnakeTransitionAnimator

@export var animation_player : AnimationPlayer

func play_transition():
	visible = true
	animation_player.play("apple_runner")
	await animation_player.animation_finished
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.DrivingScene)