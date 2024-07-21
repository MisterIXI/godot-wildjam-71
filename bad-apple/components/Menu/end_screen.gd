extends Node3D

@export var buttons :Array[Button]

func _ready():
	buttons[0].mouse_entered.connect(_on_mouse_entered.bind(0))
	buttons[1].mouse_entered.connect(_on_mouse_entered.bind(1))
	buttons[2].mouse_entered.connect(_on_mouse_entered.bind(2))
	buttons[3].mouse_entered.connect(_on_mouse_entered.bind(3))

	buttons[0].mouse_exited.connect(_on_mouse_exited.bind(0))
	buttons[1].mouse_exited.connect(_on_mouse_exited.bind(1))
	buttons[2].mouse_exited.connect(_on_mouse_exited.bind(2))
	buttons[3].mouse_exited.connect(_on_mouse_exited.bind(3))

func _on_mouse_entered(index: int):

	buttons[index].scale = Vector2(0.33,0.33)

func _on_mouse_exited(index : int):

	buttons[index].scale = Vector2(0.29,0.29)

func _on_topdowngame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.TopDownShooterScene)


func _on_fpsgame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.ShootingScene)


func _on_drivinggame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.DrivingScene)

func _on_snakegame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.SnakeScene)

