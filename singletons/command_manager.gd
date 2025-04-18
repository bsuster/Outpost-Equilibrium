extends Node

signal command_completed

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
	
	if command_title == "status":
		return run_status_command()
	
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

func run_status_command() -> String:
	var status_text: String= ""
	status_text += "\n==============================\n"
	status_text += " OUTPOST SYSTEM STATUS REPORT "
	status_text += "\n==============================\n\n"
	for resource in ["power", "oxygen", "food"]:
		var value = SystemManager.get(resource)
		var label = resource.to_upper() + ""
		#var warning = get_status_warning(value)
		status_text += label + ": " + str(value) + "%\n"# + warning
	status_text += "\n==============================\n"
	return status_text
