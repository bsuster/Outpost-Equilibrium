extends Node

signal day_updated

var oxygen: int = 100
var food: int = 100
var power: int = 100
var day: int = 1:
	set(new_value):
		day = new_value
		day_updated.emit()

var can_advance_day: bool = false

func apply_effect(effect_name: String, value) -> void:
	var new_value = get(effect_name) + value
	set(effect_name, new_value)

func toggle_can_advance_day():
	can_advance_day = not can_advance_day
