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
	var event_data = Globals.base_game_data["events"]
	
	for event in event_data:
		var new_event: Event = Event.new(event, event_data[event])
		events.append(new_event)

func refresh_active_events():
	for event in active_events:
		event.duration -= 1
		if event.duration <= 0:
			event.remove_effects()
			active_events.erase(event)
	
	randomize()
	while randi_range(1, 10) == 10:
		var new_event: Event = available_events.pick_random().clone()
		var is_event_active: bool = false
		for active_event in active_events:
			if active_event.title == new_event.title:
				is_event_active = true
			if is_event_active:
				break
		if not is_event_active:
			active_events.append(new_event)
			new_event.apply_effects()
	

func get_random_event() -> Event:
	var coin_flip = randi_range(0,1) == 1
	
	if coin_flip:
		return null
	
	return events.pick_random()
