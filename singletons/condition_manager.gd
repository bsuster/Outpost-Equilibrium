extends Node

func get_callable_by_name(callable_name: String) -> Callable:
	if has_method(callable_name):
		return Callable(self, callable_name)
	return Callable()

func has_min_power_10() -> bool:
	return SystemManager.power >= 10 and not can_advance_day()

func deploy_panels_enabled():
	return not SystemManager.deploy_panels_disabled and not can_advance_day()

func has_min_air_5():
	return SystemManager.oxygen >= 5 and not can_advance_day()

func can_advance_day():
	return SystemManager.can_advance_day

func can_skip():
	return not SystemManager.can_advance_day
