extends Node

func get_callable_by_name(callable_name: String) -> Callable:
	if has_method(callable_name):
		return Callable(self, callable_name)
	return Callable()

func has_min_power_10() -> bool:
	return SystemManager.power >= 10 and not SystemManager.can_advance_day

func no_dust_storm():
	for event in EventManager.active_events:
		if event.title == "dust_storm":
			return false
	return true

func has_min_air_5():
	return SystemManager.oxygen >= 5 and not SystemManager.can_advance_day

func can_advance_day():
	return SystemManager.can_advance_day
