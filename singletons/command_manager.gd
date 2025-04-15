extends Node


var commands: Dictionary


func _init():
	_restore_data()


func _restore_data():
	var path = "res://data/output.json"
	if not FileAccess.file_exists(path):
		return
	
	var output_data_string = FileAccess.get_file_as_string(path)
	var output_data = JSON.parse_string(output_data_string)
	var commands_data = output_data["commands"]
	for command in commands_data:
		commands[command] = commands_data[command]

func has_command(command) -> bool:
	return commands.has(command)

func exec_command(command) -> String:
	var command_dict = commands[command]
	var _is_success = true
	if not command_dict.has_all(["success", "failure", "effects"]):
		return command_dict["success"][0]
	return ""
	
