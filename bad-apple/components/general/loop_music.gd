extends AudioStreamPlayer


func _ready():
	finished.connect(_on_finished)


func _on_finished():
	play(0)
