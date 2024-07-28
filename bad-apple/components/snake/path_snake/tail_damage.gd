extends MeshInstance3D

@export var material_main :Material
@export var material_damaged: Material
@onready var timer : Timer = $Timer


func _ready():
	timer.timeout.connect(on_timer_timeout)
	
func get_damage():
	print("Tail_damage but material dont work")
	set_surface_override_material(0, material_damaged)
	timer.start()

func on_timer_timeout():
	set_surface_override_material(0, material_main)