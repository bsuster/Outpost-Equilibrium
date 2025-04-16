# Manages saving/loading save data
extends Node

var base_game_data: Dictionary


func _init() -> void:
	_restore_data()

# Really simple save file implementation. Just saving some variables to a dictionary
func save_game():
	pass


# If check_only is true it will only check for a valid save file and return true or false without
# restoring any data
func load_game(_check_only=false):
	pass


# Restores data from the JSON dictionary inside the save files
func _restore_data():
	var path = "res://data/data.json"
	if not FileAccess.file_exists(path):
		return
	
	var data_string = FileAccess.get_file_as_string(path)
	base_game_data = JSON.parse_string(data_string)
