extends Node

var events: Array

var active_events: Array[Event]

func _init() -> void:
	_restore_data()

func _restore_data() -> void:
	var event_data = Globals.base_game_data["events"]
	
	for event in event_data:
		var title = event
		var description = event_data[event].description
		var modifiers = event_data[event].modifiers
		var new_event: Event = Event.new(title, description, modifiers)
		events.append(new_event)

func get_random_event() -> Event:
	var coin_flip = randi_range(0,1) == 1
	
	if coin_flip:
		return null
	
	return events.pick_random()
