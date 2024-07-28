extends Area3D
class_name PathSnakePart

@export var Head: Node3D
@export var Body: Node3D
@export var Tail: Node3D
@export var animation_player: AnimationPlayer

func play_animation(_anim_name: String):
	animation_player.play(_anim_name)

func switch_to_head():
	Head.visible = true
	Body.visible = false
	Tail.visible = false

func switch_to_body():
	Head.visible = false
	Body.visible = true
	Tail.visible = false

func switch_to_tail():
	Head.visible = false
	Body.visible = false
	Tail.visible = true


func set_damage_visual():
	Tail.get_damage()