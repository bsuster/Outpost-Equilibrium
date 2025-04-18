extends Node

func has_power(system_ref, amount):
	return func():
		return system_ref.get("power") >= amount

func no_dust_storm(env_ref):
	return func():
		return not env_ref.dust_storm_active
