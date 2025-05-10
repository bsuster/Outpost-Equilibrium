extends Node

func get_callable_by_name(callable_name: String) -> Callable:
	if has_method(callable_name):
		return Callable(self, callable_name)
	return Callable()

func update_power(value):
	SystemManager.power += value
	return { "resource": "Power", "value": value }

func update_power_range(value):
	randomize()
	var val = randi_range(value[0], value[1])
	SystemManager.power += val
	return { "resource": "Power", "value": val }

func update_food(value):
	SystemManager.food += value
	return { "resource": "Food", "value": value }

func update_food_range(value):
	randomize()
	var val = randi_range(value[0], value[1])
	SystemManager.food += val
	return { "resource": "Food", "value": val }

func update_oxygen(value):
	SystemManager.oxygen += value
	return { "resource": "Oxygen", "value": value }

func update_oxygen_range(value: Array):
	randomize()
	var val = randi_range(value[0], value[1])
	SystemManager.oxygen += val
	return { "resource": "Oxygen", "value": val }

func update_day(value):
	SystemManager.day += value
	return { "resource": "Day", "value": value }

func food_depletion_bonus(value):
	SystemManager.daily_scaling["food"] += value
	return { "resource": "Food Depletion Bonus", "value": value }

func power_depletion_bonus(value):
	SystemManager.daily_scaling["power"] += value
	return { "resource": "Power Depletion Bonus", "value": value }

func oxygen_depletion_bonus(value):
	SystemManager.daily_scaling["oxygen"] += value
	return { "resource": "Oxygen Depletion Bonus", "value": value }

func optimize_resource(resource, value):
	call("%s_depletion_bonus" % [resource], value)

func deploy_panels_disabled(value):
	SystemManager.apply_effect("deploy_panels_disabled", value)
