extends Control

@export var hseperator: HSeparator
@export var mouse_grid: GridContainer

func set_mouse_settings_visibility(_visible: bool) -> void:
	mouse_grid.visible = _visible
	hseperator.visible = _visible