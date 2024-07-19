extends CanvasLayer
class_name UI_Controller

########### NEEDLE SETTINGS 
const MIN_ROTATION : float = -111
const MAX_ROTATION : float = 111

@onready var tacho_label : Label = $HUD/Tacho_MarginCon/Panel/kmh_label
@onready var tacho_needle : TextureRect = $HUD/Tacho_MarginCon/Panel2/tacho_needle
# collectable value
@onready var collectable_value : Label = $HUD/Player_coin_progress/coin_value/Label
@export var life_array : Array[TextureRect]  = []

func set_tacho (x : float):

	set_tacho_needle(x)

	var info = "%.0f km/h" % x
	tacho_label.text = info


func set_tacho_needle (speed : float):
	tacho_needle.rotation_degrees  = speed - 110

func update_collectable(_text : String):
	collectable_value.text = _text

func update_life(value : int):
	print ("get damage value:", value)
	for x in range(0,5):
		if value -1>= x:
			life_array[x].visible = true
		else:
			life_array[x].visible = false