class_name FpsChangeResourceLabel
extends Node

@export_group("Text")
@export var is_ammo : bool = false
@export var is_health : bool = false
@export var is_armor : bool = false
@export var text_prefix : String = ""
@export var text_suffix : String = ""

@export_group("Weapon")
@export var is_shotgun : bool = false
@export var is_knife : bool = false
@export var active_theme : LabelSettings = null
@export var inactive_theme : LabelSettings = null

var _label : Label
var _resource_manager : FpsResourceManager

func _ready():
	_label = get_parent()
	_resource_manager = get_node("%FpsResourceManager")

	if _resource_manager == null:
		assert(false, str(name) + " has to have a FpsResourceManager in scene. Path: " + str(get_path()))
		return

	_resource_manager.weapon_changed.connect(_on_weapon_changed)
	_resource_manager.ammo_changed.connect(_on_ammo_changed)
	_resource_manager.health_changed.connect(_on_health_changed)
	_resource_manager.armor_changed.connect(_on_armor_changed)

	_on_weapon_changed(_resource_manager.weapon)
	_on_ammo_changed(_resource_manager.ammo)
	_on_health_changed(_resource_manager.health)
	_on_armor_changed(_resource_manager.armor)


func _on_weapon_changed(weapon : FpsResourceManager.WEAPOND_TYPE) -> void:
	if not is_shotgun and not is_knife:
		return
	if (is_shotgun and weapon == FpsResourceManager.WEAPOND_TYPE.SHOTGUN) or (is_knife and weapon == FpsResourceManager.WEAPOND_TYPE.KNIFE):
		_label.label_settings = active_theme
		return
	_label.label_settings = inactive_theme


func _on_ammo_changed(ammo : int) -> void:
	if is_ammo:
		_label.text = text_prefix + str(ammo) + text_suffix


func _on_health_changed(health : int) -> void:
	if is_health:
		_label.text = text_prefix + str(health) + text_suffix


func _on_armor_changed(armor : int) -> void:
	if is_armor:
		_label.text = text_prefix + str(armor) + text_suffix
