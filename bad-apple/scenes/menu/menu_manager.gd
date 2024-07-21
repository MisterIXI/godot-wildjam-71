extends Control
class_name MenuManager

@export var MainMenuNode: MenuMain
@export var PauseMenuNode: MenuPause
@export var CreditsMenuNode: MenuCredits
@export var SettingsMenuNode: MenuSettings

var settings: MenuSettings:
	get: return SettingsMenuNode

signal master_volume_slider_changed(volume: float)
signal music_volume_slider_changed(volume: float)
signal sfx_volume_slider_changed(volume: float)

signal mouse_sense_slider_changed(sense: float)

@export var SnakeScene: PackedScene
@export var DrivingScene: PackedScene
@export var ShootingScene: PackedScene
@export var TopDownShooterScene: PackedScene

var current_open_menu: Control = null
var previous_menu: Control = null
var mouse_mode: int = Input.MOUSE_MODE_VISIBLE

func _ready():
	_connect_settings_sliders()
	_hide_all()
	_set_slider_current_values()
	

func _connect_settings_sliders():
	SettingsMenuNode.slider_master_volume.value_changed.connect(_on_master_volume_slider_changed)
	SettingsMenuNode.slider_music_volume.value_changed.connect(_on_music_volume_slider_changed)
	SettingsMenuNode.slider_sfx_volume.value_changed.connect(_on_sfx_volume_slider_changed)
	SettingsMenuNode.slider_mouse_sense.value_changed.connect(_on_mouse_sense_slider_changed)
	master_volume_slider_changed.connect(_change_master_volume)
	music_volume_slider_changed.connect(_change_music_volume)
	sfx_volume_slider_changed.connect(_change_sfx_volume)

func _set_slider_current_values():
	master_volume_slider_changed.emit(SettingsMenuNode.slider_master_volume.value)
	music_volume_slider_changed.emit(SettingsMenuNode.slider_music_volume.value)
	sfx_volume_slider_changed.emit(SettingsMenuNode.slider_sfx_volume.value)

func _on_master_volume_slider_changed(value: float): master_volume_slider_changed.emit(value)
func _on_music_volume_slider_changed(value: float): music_volume_slider_changed.emit(value)
func _on_sfx_volume_slider_changed(value: float): sfx_volume_slider_changed.emit(value)

func _on_mouse_sense_slider_changed(value: float): mouse_sense_slider_changed.emit(value)

var master_volume: float:
	get: return SettingsMenuNode.slider_master_volume.value

var music_volume: float:
	get: return SettingsMenuNode.slider_music_volume.value

var sfx_volume: float:
	get: return SettingsMenuNode.slider_sfx_volume.value

var mouse_sense: float:
	get: return SettingsMenuNode.slider_mouse_sense.value

func go_back():
	if current_open_menu != null:
		current_open_menu.hide()
	if previous_menu != null:
		previous_menu.show()
		current_open_menu = previous_menu

func quit():
	get_tree().quit()

func show_credits():
	previous_menu = current_open_menu
	current_open_menu = CreditsMenuNode
	CreditsMenuNode.show()
	# if previous_menu != null:
	# 	previous_menu.hide()

func show_settings():
	previous_menu = current_open_menu
	current_open_menu = SettingsMenuNode
	SettingsMenuNode.show()
	# if previous_menu != null:
	# 	previous_menu.hide()

func start_game():
	# load snake scene
	get_tree().change_scene_to_packed(SnakeScene)
	current_open_menu.hide()
	current_open_menu = null

func restart_game():
	get_tree().reload_current_scene()
	current_open_menu = null
	previous_menu = null
	resume_game()
	_hide_all()
	

func pause_game():
	match current_open_menu:
		MainMenuNode:
			return
		CreditsMenuNode:
			go_back()
			return
		SettingsMenuNode:
			go_back()
			return
		PauseMenuNode:
			resume_game()
			return
	get_tree().paused = true
	previous_menu = current_open_menu
	current_open_menu = PauseMenuNode
	PauseMenuNode.show()
	mouse_mode = Input.get_mouse_mode()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	# move menu to top of ui stack
	get_parent().move_child(self, -1)

func resume_game():
	get_tree().paused = false
	if current_open_menu != null:
		current_open_menu.hide()
	current_open_menu = null
	previous_menu = null
	Input.set_mouse_mode(mouse_mode)
	_hide_all()

func show_main_menu():
	previous_menu = null
	current_open_menu = MainMenuNode
	MainMenuNode.show()

func enable_mouse_settings():
	SettingsMenuNode.show_mouse_settings()

func _input(event):
	if event.is_action_pressed("pause"):
		pause_game()

func _hide_all():
	MainMenuNode.hide()
	PauseMenuNode.hide()
	CreditsMenuNode.hide()
	SettingsMenuNode.hide()

func _change_master_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), linear_to_db(value/100))

func _change_sfx_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear_to_db(value/100))

func _change_music_volume(value: float):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), linear_to_db(value/100))