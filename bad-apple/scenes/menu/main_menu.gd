extends Control
class_name MainMenu
@export var BTNStartGame: Button
@export var BTNOptions: Button
@export var BTNCredits: Button
@export var BTNQuit: Button

func _ready():
	# check if web build
	if OS.get_name() == "Web":
		BTNQuit.disabled = true



func _on_btn_start_game_pressed():
	print("Start Game")
	pass # Replace with function body.


func _on_btn_options_pressed():
	pass # Replace with function body.


func _on_btn_credits_pressed():
	pass # Replace with function body.


func _on_btn_quit_pressed():
	pass # Replace with function body.
