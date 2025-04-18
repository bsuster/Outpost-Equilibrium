extends Control

@export var background_songs: Array[AudioStream]

@onready var terminal: Terminal = $Terminal
@onready var background_player: AudioStreamPlayer2D = $BackgroundPlayer

var current_day: int = 0
var current_event: Event = null

func _ready() -> void:
	background_player.play()


func _play_next() -> void:
	var next_song = background_player.stream
	while next_song == background_player.stream:
		next_song = background_songs.pick_random()
	
	background_player.stream = next_song
	background_player.play()


func _on_background_player_finished() -> void:
	_play_next()

func _next_day() -> void:
	terminal.disable_input()
	current_day += 1
	randomize()
	var has_event: bool = randi_range(4, 4) == 1
	current_event = EventManager.get_random_event() if has_event else null
	
	
	var day_string = "Day: %s" % [current_day]
	terminal.print_terminal_output(day_string)
	await terminal.printing_done
	terminal.enable_input()


func _on_intro_done():
	_next_day()
