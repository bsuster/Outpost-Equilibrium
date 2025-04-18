extends Node

class_name Command

var title: String
var description: String
var effects := {}
var success_text := [] # Array of success messages
var failure_text := [] # Array of fail messages
var condition_func: Callable # Optional function reference to check usage

func _init(t: String, command_dict: Dictionary):
	title = t
	description = command_dict.description
	effects = command_dict.effects
	success_text = command_dict.success_text
	failure_text = command_dict.failure_text

func can_run() -> bool:
	return condition_func.call()

func get_success_text() -> String:
	return success_text.pick_random()

func get_failure_text() -> String:
	if failure_text.is_empty():
		return ">> Command failed unexpectedly."
	return failure_text.pick_random()
