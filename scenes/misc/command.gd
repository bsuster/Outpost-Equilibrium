extends Node

class_name Command

var title: String
var description: String
var effects := {}
var success_text := [] # Array of success messages
var failure_text := [] # Array of fail messages
var condition: Callable # Optional function reference to check usage

func _init(t: String, command_dict: Dictionary):
	title = t
	for prop in command_dict:
		set(prop, command_dict[prop])
	if command_dict.has("condition") and command_dict.condition != null:
		condition = ConditionManager.get_callable_by_name(command_dict.condition)

func can_run() -> bool:
	return condition.is_null() or condition.call()

func run() -> String:
	if not effects.is_empty():
		for effect in effects:
			SystemManager.apply_effect(effect, effects[effect])
		SystemManager.toggle_can_advance_day()
	
	return get_success_text()

func get_success_text() -> String:
	return success_text.pick_random()

func get_failure_text() -> String:
	if failure_text.is_empty():
		return ">> Command failed unexpectedly."
	return failure_text.pick_random()
