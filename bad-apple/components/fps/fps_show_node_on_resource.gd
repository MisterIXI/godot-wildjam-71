class_name FpsShowNodeOnResource
extends Node
## Shows on on resource event

## Duration in seconds of the opacity fade animation.
@export var node : Node = null
@export var on_health_damage : bool = false
@export var on_health_heal : bool = false
@export var on_armor_damage : bool = false
@export var on_armor_heal : bool = false


func _ready():
	FpsResourceManagerInstance.health_damaged.connect(_on_health_damaged)
	FpsResourceManagerInstance.health_healed.connect(_on_health_healed)
	FpsResourceManagerInstance.armor_damaged.connect(_on_armor_damaged)
	FpsResourceManagerInstance.armor_healed.connect(_on_armor_healed)


func _on_health_damaged():
	if on_health_damage:
		node.show()

func _on_health_healed():
	if on_health_heal:
		node.show()

func _on_armor_damaged():
	if on_armor_damage:
		node.show()

func _on_armor_healed():
	if on_armor_heal:
		node.show()
