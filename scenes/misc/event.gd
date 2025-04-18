extends Node

class_name Event

var title: String = ""
var description: String = ""
var effects: Dictionary
var duration: int # Number of days the effect lasts

func _init(t: String, event: Dictionary) -> void:
	title = t
	for prop in event:
		set(prop, event[prop])
	#title = t
	#description = d
	#effects = m

func apply_effects() -> void:
	for effect in effects:
		SystemManager.apply_effect(effect, true)

func clone() -> Event:
	return Event.new(title, {
		"description": description,
		"effects": effects,
		"duration": duration
	})
