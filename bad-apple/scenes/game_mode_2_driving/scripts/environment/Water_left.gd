extends MeshInstance3D

var material : Material
func _ready():
	material = mesh.surface_get_material(0)