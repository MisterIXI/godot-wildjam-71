extends MeshInstance3D


@export var viewport_texture : ViewportTexture

func _ready():
	var _mat = get_surface_override_material(0)
	_mat.set("albedo_texture", viewport_texture)