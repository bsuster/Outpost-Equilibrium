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
	var change_vals: Dictionary
	if not args.is_empty():
		print(is_valid_argument(arg))
	if not effects.is_empty():
		for effect in effects:
			var callable = EffectManager.get_callable_by_name(effect)
			if args.is_empty():
				change_vals[effect] = callable.call(effects[effect])
			else:
				change_vals[effect] = callable.call(arg, effects[effect])
		SystemManager.set_can_advance_day(true)
	
	return get_success_text(change_vals)

func get_success_text(change_vals) -> String:
	var s_text = [success_text.pick_random()]
	for effect in change_vals:
		var change_val = change_vals[effect]
		var change_val_color = "green" if change_val.value > 0 else "red"
		var change_sign = "+" if change_val.value > 0 else "-"
		var change_val_text = "   %s: [color=%s]%s%s[/color]" % [
			change_val_color,
			change_val.resource,
			change_sign,
			str(change_val.value)
			]
		s_text.append(change_val_text)
	return "\n".join(s_text)

func get_failure_text() -> String:
	if failure_text.is_empty():
		return ">> Command failed unexpectedly."
	return failure_text.pick_random()
