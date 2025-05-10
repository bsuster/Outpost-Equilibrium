extends Node

signal active_events_updated

var events: Array[Event]

var active_events: Array[Event]
var cooldown_events: Array[Event]
var DEBUG_MODE: bool = false
var DEBUG_EVENTS_ON: bool = false

var is_updating_events: bool = false

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
		for event in output:
			var is_on_cooldown: bool = false
			for cooldown_event in cooldown_events:
				if cooldown_event.title == event.title:
					is_on_cooldown = true
					break
			if is_on_cooldown:
				output.erase(event)
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
	is_updating_events = true
	cooldown_events.clear()
	var events_to_erase: Array[Event] = []
	for event in active_events:
		event.duration -= 1
		if event.duration <= 0:
			if event.is_removable:
				event.remove_effects()
			events_to_erase.append(event)
		else:
			event.apply_effects()
	
	for event in events_to_erase:
		active_events.erase(event)
		cooldown_events.append(event)
	
	randomize()
	var is_adding_event = _get_add_event(2) if active_events.is_empty() else _get_add_event(5)
	while is_adding_event:
		if available_events.is_empty():
			return
		var new_event: Event = available_events.pick_random().clone()
		active_events.append(new_event)
		new_event.apply_effects()
		is_adding_event = _get_add_event(5)
	is_updating_events = false
	active_events_updated.emit()

func clear_active_events() -> void:
	for event in active_events:
		event.remove_effects()
		active_events.erase(event)

func _get_add_event(max_val: int) -> bool:
	if DEBUG_MODE:
		return DEBUG_EVENTS_ON
	return randi_range(1, max_val) == 1
