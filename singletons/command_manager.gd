extends Node


var commands: Dictionary

var previous_command: String = ""

func _init():
	_restore_data()

func _restore_data():
	commands = Globals.base_game_data["commands"]

func has_command(command: String) -> bool:
	return commands.has(command)

func exec_command(command) -> String:
	var command_dict = commands[command]
	if previous_command == "exit":
		if command == "yes":
			get_tree().quit()
		elif command == "no":
			previous_command = ""
			return ""
		else:
			return ""
	if not command_dict.has_all(["success", "failure", "effects"]):
		previous_command = command
		return command_dict["success"][0]
	
	randomize()
	var is_success = randi_range(0,10) <= 7
	if is_success:
		previous_command = command
		return command_dict["success"].pick_random()
	
	previous_command = command
	return command_dict["failure"].pick_random()
	
