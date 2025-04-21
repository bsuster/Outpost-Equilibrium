extends Node

var events: Array[Event]

var active_events: Array[Event]

var available_events: Array[Event]:
	get:
		var output: Array[Event]
		for event in events:
			var is_event_active: bool = false
			for active_event in active_events:
				if active_event.title == event.title:
					is_event_active = true
					break
			if not is_event_active:
				output.append(event)
		return output

func _init() -> void:
	_restore_data()

func _restore_data() -> void:
	var path = "res://data/events.json"
	if not FileAccess.file_exists(path):
		return
	
	var data_string = FileAccess.get_file_as_string(path)
	var event_data = JSON.parse_string(data_string)
	
	for event in event_data:
		var new_event: Event = Event.new(event_data[event])
		events.append(new_event)

func refresh_active_events():
	for event in active_events:
		event.duration -= 1
		if event.duration <= 0:
			event.remove_effects()
			active_events.erase(event)
	
	randomize()
	while randi_range(1, 4) == 1:
		if available_events.is_empty():
			return
		var new_event: Event = available_events.pick_random().clone()
		active_events.append(new_event)
		new_event.apply_effects()
	

func get_random_event() -> Event:
	var coin_flip = randi_range(0,1) == 1
	
	if coin_flip:
		return null
	
	return events.pick_random()
