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

func deploy_panels_disabled(value) -> void:
	SystemManager.apply_effect("deploy_panels_disabled", value)
