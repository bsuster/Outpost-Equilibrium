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
	if command_dict.has("description"):
		description = command_dict.description
	if command_dict.has("effects"):
		effects = command_dict.effects
	if command_dict.has("success_text"):
		success_text = command_dict.success_text
	if command_dict.has("failure_text"):
		failure_text = command_dict.failure_text
	if command_dict.has("condition"):
		condition_func = ConditionManager.get_callable_by_name(command_dict.condition)

func can_run() -> bool:
	return condition_func.is_null() or condition_func.call()

func run() -> String:
	if not effects.is_empty():
		for effect in effects:
			SystemManager.apply_effect(effect, effects[effect])
	
	return get_success_text()

func get_success_text() -> String:
	return success_text.pick_random()

func get_failure_text() -> String:
	if failure_text.is_empty():
		return ">> Command failed unexpectedly."
	return failure_text.pick_random()
