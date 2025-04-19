extends Node

signal day_updated

var oxygen: int = 100:
	set(new_value):
		oxygen = new_value
		_check_game_over()
var food: int = 100:
	set(new_value):
		food = new_value
		_check_game_over()
var power: int = 100:
	set(new_value):
		power = new_value
		_check_game_over()
var day: int = 0:
	set(new_value):
		day = new_value
		day_updated.emit()
var deploy_panels_disabled: bool = false
var is_game_over: bool = false

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
