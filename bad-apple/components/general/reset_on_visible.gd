class_name ResetOnVisible
extends Node
## Does an action when the parent node becomes visible.

@export_group("General")
@export var time_scale : bool = false

@export_group("Reset windows")
## Close all the windows in windows_to_close and open all the windows in windows_to_open when the button is clicked.
@export var reset_windows : bool = false
## Windows to close when the button is clicked. (Needs swap_windows to be enabled)
@export var windows_to_close : Array[Node] = []
## Windows to open when the button is clicked. (Needs swap_windows to be enabled)
@export var windows_to_open : Array[Node] = []


var _parent
func _ready():
	_parent = get_parent()
	_parent.visibility_changed.connect(_on_visibility_changed)
	_on_visibility_changed()


func _on_visibility_changed():
	if _parent.visible:
		if reset_windows:
			for window in windows_to_close:
				window.hide()
			for window in windows_to_open:
				window.show()

		if time_scale:
			get_tree().paused = false