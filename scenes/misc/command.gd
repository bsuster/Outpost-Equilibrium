extends Node

class_name Command

var title: String
var description: String
var effects := {}
var success_text := [] # Array of success messages
var failure_text := [] # Array of fail messages
var condition: Callable # Optional function reference to check usage
var args := []

func _init(t: String, command_dict: Dictionary):
	title = t
	for prop in command_dict:
		set(prop, command_dict[prop])
	if command_dict.has("condition") and command_dict.condition != null:
		condition = ConditionManager.get_callable_by_name(command_dict.condition)
	args = command_dict.get("args", [])

func can_run() -> bool:
	return condition.is_null() or condition.call()

func is_valid_argument(arg) -> bool:
	return args.has(arg)

func run(arg: String = "") -> String:
	if not args.is_empty():
		print(is_valid_argument(arg))
	if not effects.is_empty():
		for effect in effects:
			var callable = EffectManager.get_callable_by_name(effect)
			if args.is_empty():
				callable.call(effects[effect])
			else:
				callable.call(arg, effects[effect])
		SystemManager.set_can_advance_day(true)
	
	return get_success_text()

func get_success_text() -> String:
	return success_text.pick_random()

func get_failure_text() -> String:
	if failure_text.is_empty():
		return ">> Command failed unexpectedly."
	return failure_text.pick_random()
