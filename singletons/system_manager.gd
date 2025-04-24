extends Node

signal day_updated
signal game_restarted

var oxygen: int = 100:
	set(new_value):
		oxygen = clamp(new_value, 0, 100)
		_check_game_over()
var food: int = 100:
	set(new_value):
		food = clamp(new_value, 0, 100)
		_check_game_over()
var power: int = 100:
	set(new_value):
		power = clamp(new_value, 0, 100)
		_check_game_over()
var day: int = 0:
	set(new_value):
		day = new_value
		_handle_day_change()
var deploy_panels_disabled: bool = false
var is_game_over: bool = false

var default_degradation_values: Dictionary = {
	"power": -15,
	"oxygen": -10,
	"food": -5
}

var can_advance_day: bool = true

func apply_effect(effect_name: String, value) -> void:
	var new_value = value
	if value is int or value is float:
		var effect_val = get(effect_name)
		new_value = clamp(effect_val + value, 0, 100)
	set(effect_name, new_value)

func toggle_can_advance_day():
	can_advance_day = not can_advance_day

func set_can_advance_day(value: bool):
	can_advance_day = value

func _check_game_over():
	if [food, oxygen, power].any(func(val): return val <= 0):
		is_game_over = true

func restart_game():
	is_game_over = 0
	game_restarted.emit()
	day = 1
	power = 85
	oxygen = 90
	food = 95
	EventManager.clear_active_events()

func get_resource_label(resource: String) -> String:
	match resource.to_lower():
		"power":
			return "POW"
		"food":
			return "FOD"
		"oxygen":
			return "OXY"
	return ""

func get_percent_to_bar(value) -> String:
	var bar_count = value / 5
	var output = ""
	for i in bar_count:
		output += "█"
	return output

func _handle_day_change() -> void:
	for prop in default_degradation_values:
		set(prop, get(prop) + default_degradation_values[prop])
	day_updated.emit()
	
