extends Control
class_name MenuSettings

@export var slider_master_volume: HSlider
@export var slider_music_volume: HSlider
@export var slider_sfx_volume: HSlider

@export var slider_mouse_sense: HSlider
@export var h_seperator: HSeparator

func show_mouse_settings():
	h_seperator.show()
	slider_mouse_sense.show()
