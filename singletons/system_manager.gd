extends Node

var oxygen: int = 100
var food: int = 100
var power: int = 0

func apply_effect(effect_name: String, value) -> void:
	var new_value = get(effect_name) + value
	set(effect_name, new_value)
