extends Node

signal day_updated
signal game_restarted

var oxygen: int = 100:
	set(new_value):
		oxygen = clamp(new_value, 0, 100)
var food: int = 100:
	set(new_value):
		food = clamp(new_value, 0, 100)
var power: int = 100:
	set(new_value):
		power = clamp(new_value, 0, 100)
var day: int = 0:
	set(new_value):
		day = new_value
		_handle_day_change()
var deploy_panels_disabled: bool = false
var is_game_over: bool:
	get:
		return [power, oxygen, food].has(0)

var base_depletion: Dictionary = {
	"power": -8,
	"oxygen": -5,
	"food": -3
}

var daily_scaling: Dictionary = {
	"power": 0.25,
	"oxygen": 0.2,
	"food": 0.3
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

func restart_game():
	power = 85
	oxygen = 90
	food = 95
	EventManager.clear_active_events()
	game_restarted.emit()
	day = 1

func get_resource_label(resource: String) -> String:
	match resource.to_lower():
		"power":
			return "POW"
		"food":
			return "FOD"
		"oxygen":
			return "OXY"
	return ""

func get_percent_to_bar(current: float, max_val: float, width: int = 20, color: String = "green") -> String:
	var percent = current / max_val
	if percent <= 0.35:
		color = "red"
	elif percent <= 0.50:
		color = "yellow"
	var filled = int(percent * width)
	var empty = width - filled
	return "[[color=%s]" % color + "|".repeat(filled) + " ".repeat(empty) + "[/color]] %d%%" % int(percent * 100)

func _handle_day_change() -> void:
	for prop in base_depletion:
		set(prop, get(prop) + base_depletion[prop])
		base_depletion[prop] -= daily_scaling[prop]
	day_updated.emit()
	
