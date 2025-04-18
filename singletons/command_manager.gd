extends Node


var commands: Dictionary
var commands2: Dictionary

var previous_command: String = ""

func _init():
	_restore_data()

func _restore_data():
	commands = Globals.base_game_data["commands"]
	for command in commands:
		var new_command = Command.new(command, commands[command])
		commands2[command] = new_command

func has_command(command: String) -> bool:
	return commands.has(command)

func exec_command(command_title) -> String:
	if not commands2.has(command_title):
		if previous_command == "exit":
			return commands2["exit"].run()
		return ""
	var command: Command = commands2[command_title]
	
	if command.can_run():
		if previous_command == "exit":
			if command_title == "yes":
				get_tree().quit()
			elif command_title == "no":
				previous_command = ""
			else:
				return commands2["exit"].run()
		else:
			previous_command = command_title
		return command.run()
	previous_command = command_title
	return command.get_failure_text()

#func exec_command(command) -> String:
	#var command_dict = commands[command]
	#if previous_command == "exit":
		#if command == "yes":
			#get_tree().quit()
		#elif command == "no":
			#previous_command = ""
			#return ""
		#else:
			#return ""
	#if not command_dict.has_all(["success_text", "failure_text", "effects"]):
		#previous_command = command
		#return command_dict["success_text"][0]
	
	#randomize()
	#var is_success = randi_range(0,10) <= 7
	#if is_success:
		#previous_command = command
		#return command_dict["success_text"].pick_random()
	#
	#previous_command = command
	#return command_dict["failure_text"].pick_random()
	
