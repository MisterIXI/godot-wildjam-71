extends TextureRect

@export var texture_smile : Texture = null
@export var texture_sad : Texture = null
@export var texture_wink_left : Texture = null
@export var texture_wink_right : Texture = null
@export var switch_time : float = 1

var is_happy : bool = true
var time : float = 0

func _ready():
	FpsResourceManagerInstance.health_damaged.connect(_on_damaged)
	FpsResourceManagerInstance.armor_damaged.connect(_on_damaged)
	texture = texture_smile


func _on_damaged():
	is_happy = false
	texture = texture_sad
	await get_tree().create_timer(switch_time).timeout
	is_happy = true

func _process(delta):
	if is_happy:
		time += delta
		if time > switch_time and time < switch_time * 2:
			texture = texture_wink_left
		elif time > switch_time *2 and time < switch_time *3:
			texture = texture_smile
		elif time > switch_time * 3 and time < switch_time * 4:
			texture = texture_wink_right
		elif time > switch_time * 4:
			texture = texture_smile
			time = 0
