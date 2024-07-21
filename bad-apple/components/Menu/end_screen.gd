extends Node3D

@export var buttons :Array[Button]

func _ready():
	buttons[0].mouse_entered.connect(_on_mouse_entered)
	buttons[1].mouse_entered.connect(_on_mouse_entered)
	buttons[2].mouse_entered.connect(_on_mouse_entered)
	buttons[3].mouse_entered.connect(_on_mouse_entered)

	buttons[0].mouse_exited.connect(_on_mouse_exited)
	buttons[1].mouse_exited.connect(_on_mouse_exited)
	buttons[2].mouse_exited.connect(_on_mouse_exited)
	buttons[3].mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	pass
	#scale = Vector3(1.1,1.1,1.1)

func _on_mouse_exited():
	pass
	#scale = Vector3.ONE

func _on_topdowngame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.TopDownShooterScene)


func _on_fpsgame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.ShootingScene)


func _on_drivinggame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.DrivingScene)

func _on_snakegame_pressed():
	get_tree().change_scene_to_packed.call_deferred(GlobMenu.SnakeScene)

