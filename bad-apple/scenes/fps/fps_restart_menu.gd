extends Control

var _labels : Control = null

func _ready():
	_labels = get_node("Labels")

	if not _labels:
		assert(false, str(name) + " requires to have a child called Labels to function. Path: " + str(get_path()))
	_labels.hide()

	FpsResourceManagerInstance.health_changed.connect(_on_health_changed)


func _on_health_changed(health : int) -> void:
	if health <= 0:
		_labels.show()


func _input(_event):
	if _labels.visible and Input.is_action_just_pressed("r"):
		FpsResourceManagerInstance.reset()
		get_tree().paused = false
		get_tree().reload_current_scene()
		
