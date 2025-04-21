extends Node

class_name Event

var title: String = ""
var description: String = ""
var effects: Dictionary
var duration: int # Number of days the effect lasts
var is_removable: bool = false

func _init(event: Dictionary) -> void:
	for prop in event:
		set(prop, event[prop])

func apply_effects() -> void:
	for effect in effects:
		var callable = EffectManager.get_callable_by_name(effect)
		callable.call(effects[effect].value)

func remove_effects() -> void:
	for effect in effects:
		if not is_removable:
			return
		var callable = EffectManager.get_callable_by_name(effect)
		callable.call(false)

func clone() -> Event:
	return Event.new({
		"title": title,
		"description": description,
		"effects": effects,
		"duration": duration,
		"is_removable": is_removable
	})
