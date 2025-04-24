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
	terminal.disable_input()
	await get_tree().create_timer(2).timeout
	EventManager.refresh_active_events()
	if SystemManager.is_game_over:
		_show_game_over_screen()
		return
	if terminal.is_printing:
		await terminal.printing_done
	var day_string = "\nDay: %s" % [SystemManager.day]
	terminal.print_terminal_output(day_string)
	await terminal.printing_done
	terminal.print_terminal_output(CommandManager.get_status_message())
	await terminal.printing_done
	SystemManager.set_can_advance_day(false)
	terminal.enable_input()
#
func _on_intro_done():
	terminal.try_submit_input("next")

func _show_game_over_screen() -> void:
	var power_color = "red" if SystemManager.power <= 0 else "white"
	var oxygen_color = "red" if SystemManager.oxygen <= 0 else "white"
	var food_color = "red" if SystemManager.food <= 0 else "white"
	var game_over_art = [
		"\n[ !! SYSTEM FAILURE !! ]",
		"",
		"CRITICAL SYSTEMS OFFLINE",
		"",
		"# PWR: [color=" + power_color + "]" + SystemManager.get_percent_to_bar(SystemManager.power) + "[/color]",
		"# OXY: [color=" + oxygen_color + "]" + SystemManager.get_percent_to_bar(SystemManager.oxygen) + "[/color]",
		"# FOD: [color=" + food_color + "]" + SystemManager.get_percent_to_bar(SystemManager.food) + "[/color]",
		"",
		"> [color=red]Warning[/color]... life support failing...",
		"> Evacuation protocol: [color=red]UNAVAILABLE[/color]",
		"> Last transmission: [color=red]SIGNAL LOST[/color]",
		"> ",
		"> . . . CONNECTION TERMINATED . . .",
		"",
		"",
		"   -- THE OUTPOST HAS BEEN LOST --",
		"",
		"   Type '[color=blue]restart' to begin again.[/color]\n"
	]

	for line in game_over_art:
		terminal.print_terminal_output(line)
		await terminal.printing_done

	SystemManager.set_can_advance_day(false)
	terminal.enable_input() # Enable terminal for 'restart'
