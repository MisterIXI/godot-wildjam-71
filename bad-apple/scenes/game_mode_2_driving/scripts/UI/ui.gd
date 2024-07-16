extends CanvasLayer
class_name UI_Controller

########### NEEDLE SETTINGS 
const MIN_ROTATION : float = -111
const MAX_ROTATION : float = 111

@onready var tacho_label : Label = $HUD/MarginContainer/Panel/kmh_label
@onready var tacho_needle : TextureRect = $HUD/MarginContainer/Panel2/tacho_needle
func set_tacho (x : float):

	set_tacho_needle(x)

	var info = "%.0f km/h" % x
	tacho_label.text = info


func set_tacho_needle (speed : float):
	tacho_needle.rotation_degrees  = speed - 110