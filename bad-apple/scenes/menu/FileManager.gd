extends Node

class_name FileManager

const SAVE_PATH : String ="user://funny.bin"

@onready var settings : Global_Variables = get_node("/root/GlobalVariables")

func save_game() -> void:
      var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
      var jstr = JSON.stringify(settings.gv_Settings)
      file.store_line(jstr)
      print ("Data Saved to User.")
      file.close()

func load_game() -> void:
      var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
      if not file:
            return
      if file == null:
            return
      if FileAccess.file_exists(SAVE_PATH) == true:
            if not file.eof_reached():
                  var current_line =JSON.parse_string(file.get_line())
                  if current_line:
                        settings.gv_Settings = current_line
                        # load audio volumes
                        # load_audio_savedata()

      file.close()

func load_game_get_playername():
      var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
      if not file:
            return
      if file == null:
            return
      if FileAccess.file_exists(SAVE_PATH) == true:
            if not file.eof_reached():
                  var current_line =JSON.parse_string(file.get_line())
                  if current_line:
                        settings.gv_Settings = current_line

      file.close()
      return settings.gv_Settings["player_name"]
