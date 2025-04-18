extends Control

@export var background_songs: Array[AudioStream]

@onready var terminal: Terminal = $Terminal
@onready var background_player: AudioStreamPlayer2D = $BackgroundPlayer


func _ready() -> void:
	SystemManager.day_updated.connect(_next_day)
	background_player.play()


func _play_next_song() -> void:
	var next_song = background_player.stream
	while next_song == background_player.stream:
		next_song = background_songs.pick_random()
	
	background_player.stream = next_song
	background_player.play()


func _on_background_player_finished() -> void:
	_play_next_song()

func _next_day() -> void:
	await get_tree().create_timer(1).timeout
	#terminal.disable_input()
	if terminal.is_printing:
		await terminal.printing_done
	var day_string = "\nDay: %s" % [SystemManager.day]
	terminal.print_terminal_output(day_string)
	await terminal.printing_done
	terminal.print_terminal_output(CommandManager.run_status_command())
	await terminal.printing_done
	#terminal.enable_input()

func _on_intro_done():
	_next_day()
