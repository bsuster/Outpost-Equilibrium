extends Node


var commands: Dictionary


func _init():
	_restore_data()

func _restore_data():
	commands = Globals.base_game_data["commands"]

func has_command(command) -> bool:
	return commands.has(command)

func exec_command(command) -> String:
	var command_dict = commands[command]
	var _is_success = true
	if not command_dict.has_all(["success", "failure", "effects"]):
		return command_dict["success"][0]
	return ""
	
