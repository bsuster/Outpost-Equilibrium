extends Control

@onready var terminal_input: LineEdit = %TerminalInput
@onready var terminal_output: RichTextLabel = %TerminalOutput

var is_printing: bool = false

func _ready():
	terminal_input.set_keep_editing_on_text_submit(true)
	enable_input()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		submit_input()

func disable_input() -> void:
	terminal_input.editable = false

func enable_input() -> void:
	terminal_input.editable = true
	terminal_input.set_keep_editing_on_text_submit(true)
	terminal_input.grab_focus.call_deferred()

func submit_input():
	if is_printing:
		return
	var command = terminal_input.text
	terminal_input.clear()
	
	var command_arr = command.split(" ")
	var command_text = "> " + command
	if not CommandManager.has_command(command):
		return
	
	var command_output = CommandManager.exec_command(command_arr[0])
	
	print_terminal_output( "\n\n" + command_text + "\n\n" + command_output)

func print_terminal_output(output: String) -> void:
	is_printing = true
	var characters = output.split()
	for character in characters:
		terminal_output.text += character
		await get_tree().create_timer(0.001).timeout
	
	is_printing = false
