# Manages saving/loading save data
extends Node


# Really simple save file implementation. Just saving some variables to a dictionary
func save_game():
	pass


# If check_only is true it will only check for a valid save file and return true or false without
# restoring any data
func load_game(check_only=false):
	pass


# Restores data from the JSON dictionary inside the save files
func _restore_data():
	pass
