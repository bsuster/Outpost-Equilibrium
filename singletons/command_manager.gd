extends Node

var commands: Dictionary

var previous_command: String = ""

func _init():
	_restore_data()

func _restore_data():
	var path = "res://data/commands.json"
	if not FileAccess.file_exists(path):
		return
	
	var data_string = FileAccess.get_file_as_string(path)
	commands = JSON.parse_string(data_string)
	for command in commands:
		var new_command = Command.new(command, commands[command])
		if command == "help":
			new_command.success_text.append(get_help_message())
		commands[command] = new_command

func has_command(command: String) -> bool:
	return commands.has(command)

func exec_command(command_title) -> String:
	if not commands.has(command_title):
		if previous_command == "exit":
			return commands["exit"].run()
		return ""
	var command: Command = commands[command_title]
	
	if command_title == "status":
		return get_status_message()
	
	if command_title == "restart":
		return restart_game()
	
	if command.can_run():
		if previous_command == "exit":
			if command_title == "yes":
				get_tree().quit()
			elif command_title == "no":
				previous_command = ""
			else:
				return commands["exit"].run()
		else:
			previous_command = command_title
		return command.run()
	previous_command = command_title
	return command.get_failure_text()

func get_status_message() -> String:
	var output := []
	output.append("==============================")
	output.append(" OUTPOST SYSTEM STATUS REPORT ")
	output.append("==============================")
	for resource in ["power", "oxygen", "food"]:
		var value = SystemManager.get(resource)
		var label = SystemManager.get_resource_label(resource)
		#var warning = get_status_warning(value)
		var percent_bar = SystemManager.get_percent_to_bar(value)
		output.append(label + ": " + percent_bar)
	output.append("==============================")
	
	if EventManager.active_events.is_empty():
		output.append(" NO ACTIVE EVENTS ")
	else:
		for event in EventManager.active_events:
			output.append(" ACTIVE EVENTS:")
			output.append("- [color=red]" + event.title + "[/color]: " + event.description)
			if not event.effects.is_empty():
				output.append("    Effects")
				for effect in event.effects:
					output.append("       %s: %s" % [event.effects[effect].description, event.effects[effect].value])
				output.append("    Days left: %s" % [event.duration - 1])
		
	output.append("==============================")
	
	return "\n".join(output)

func get_help_message() -> String:
	var output := []
	output.append("=============================")
	output.append(" AVAILABLE TERMINAL COMMANDS ")
	output.append("=============================")
	
	var sorted_keys := commands.keys()
	sorted_keys.sort()
	
	for cmd in sorted_keys:
		var desc = commands[cmd].get("description")
		if desc != "exclude":
			output.append("- [color=green]" + cmd + "[/color]: " + desc)
	
	output.append("=============================")
	return "\n".join(output)

func restart_game() -> String:
	previous_command = ""
	SystemManager.restart_game()
	return ""
