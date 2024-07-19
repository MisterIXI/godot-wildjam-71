extends Node3D
class_name AppleSpawner

@export var start_delay: float = 10.5
@export var random_spawns: Node3D
@export var late_apple: Node3D

func _ready():
	_spawn_apples()

func _spawn_apples():
	late_apple.visible = false
	var apples: Array[Area3D] = []
	for letter in random_spawns.get_children():
		for child in letter.get_children():
			child = child.get_child(0)
			if child is Area3D:
				apples.append(child)
				child.visible = false
	apples.shuffle()
	# await snake animation
	await get_tree().create_timer(start_delay).timeout
	# spawn apples one by one
	var tween: Tween
	for apple in apples:
		apple.visible = true
		apple.position = Vector3.UP * 10
		# tween to let it fall from the sky
		tween = apple.create_tween()
		tween.tween_property(apple, "position", Vector3.ZERO, 1)
		tween.play()
		apple.rotation_degrees.y = randf() * 360
		# tween = apple.create_tween()
		# tween.set_loops()
		# var rotator = func(value:float):
		# 	apple.rotation_degrees.y = value
		# if randf() > 0.5:
		# 	tween.tween_method(rotator, 0,360.1,3 + randf() * 2)
		# else:
		# 	tween.tween_method(rotator, 0,-360.1,3 + randf() * 2)
		await get_tree().create_timer(randf()* 0.1).timeout
	await get_tree().create_timer(2).timeout
	var apple = late_apple
	apple.visible = true
	apple.position = Vector3.UP * 20
	# tween to let it fall from the sky
	tween = apple.create_tween()
	tween.tween_property(apple, "position", Vector3.ZERO, 1)
	tween.play()
	apple.rotation_degrees.y = randf() * 360