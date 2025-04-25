extends Control

class_name Terminal

signal printing_done

@onready var terminal_input: LineEdit = %TerminalInput
@onready var terminal_output: RichTextLabel = %TerminalOutput
@onready var type_audio_player: AudioStreamPlayer2D = $AudioPlayer_Typing

var is_printing: bool = false
var previous_command: String = ""
var is_printer_override: bool = false
var is_cycling_past_commands: bool = false

func _ready():
	SystemManager.game_restarted.connect(clear_console)
	terminal_input.focus_mode = Control.FOCUS_ALL
	terminal_input.grab_focus.call_deferred()
	if get_tree().current_scene == self:
		enable_input()
	

func _input(event):
	if event.is_action_pressed("submit_input"):
		try_submit_input()
	if event.is_action_pressed("cycle_up"):
		cycle_previous_command()
	if event.is_action_pressed("cycle_down"):
		cycle_next_command()

func cycle_previous_command() -> void:
	if not CommandManager.has_command_history:
		return
	is_cycling_past_commands = true
	terminal_input.text = CommandManager.get_previous_command()
	is_cycling_past_commands = false

func cycle_next_command() -> void:
	if not CommandManager.has_command_history:
		return
	is_cycling_past_commands = true
	terminal_input.text = CommandManager.get_next_command()
	is_cycling_past_commands = false

func disable_input() -> void:
	terminal_input.release_focus.call_deferred()
	terminal_input.editable = false

func enable_input() -> void:
	terminal_input.editable = true
	terminal_input.grab_focus.call_deferred()

func try_submit_input(force_input: String = ""):
	if is_printing or not terminal_input.editable:
		return
	var command = terminal_input.text.strip_edges() if force_input == "" else force_input
	var regex = RegEx.new()
	regex.compile("\\[.*?\\]")
	command = regex.sub(command, "", true).to_lower()
	terminal_input.clear()
	
	var command_arr = command.split(" ")
	if force_input == "":
		var command_text = "\n> " + command + "\n"
		print_terminal_output(command_text)
		await printing_done
	var command_name = command_arr[0]
	var command_obj: Command = CommandManager.get_command_by_name(command_name)
	
	var arg: String = ""
	if command_obj and not command_obj.args.is_empty():
		if command_arr.size() != 2:
			return
		arg = command_arr[1]
	
	var command_output = CommandManager.exec_command(command_arr[0], arg)
	if command_output == "":
		return
	
	if is_printing:
		await printing_done
	print_terminal_output(command_output)

func print_terminal_output(output: String) -> void:
	is_printing = true
	var typing_pitch_range = range(7, 8, 1)
	var characters = output.split()
	for character in characters:
		if character == "\n":
			randomize()
			var new_pitch_scale = typing_pitch_range.pick_random() / 10.0
			type_audio_player.pitch_scale = new_pitch_scale
		_print_character(character)
		if is_printer_override:
			is_printer_override = false
			_print_character("\n")
			is_printing = false
			printing_done.emit()
			return
		await get_tree().create_timer(0.0001).timeout
	
	_print_character("\n")
	is_printing = false
	printing_done.emit()

func _print_character(character: String) -> void:
	terminal_output.text += character
	type_audio_player.play(0.09)

func force_print_stop() -> void:
	is_printer_override = true

func clear_console() -> void:
	terminal_output.text = "Rebooting...\n\n"

func _on_terminal_input_text_changed(new_text):
	if not is_cycling_past_commands:
		CommandManager.reset_command_cycling()
