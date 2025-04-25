extends Node

func get_callable_by_name(callable_name: String) -> Callable:
	if has_method(callable_name):
		return Callable(self, callable_name)
	return Callable()

func update_power(value) -> void:
	SystemManager.power += value

func update_food(value) -> void:
	SystemManager.food += value

func update_oxygen(value) -> void:
	SystemManager.oxygen += value

func update_day(value) -> void:
	SystemManager.day += value

func food_depletion_bonus(value) -> void:
	SystemManager.daily_scaling["food"] += value

func power_depletion_bonus(value) -> void:
	SystemManager.daily_scaling["power"] += value

func oxygen_depletion_bonus(value) -> void:
	SystemManager.daily_scaling["oxygen"] += value

func optimize_resource(resource, value) -> void:
	call("%s_depletion_bonus" % [resource], value)

func deploy_panels_disabled(value) -> void:
	SystemManager.apply_effect("deploy_panels_disabled", value)
