extends Control

@export var background_songs: Array[AudioStream]

@onready var terminal: Terminal = $Terminal
@onready var background_player: AudioStreamPlayer2D = $BackgroundPlayer

var day_progression_message: Array[String] = [
	"\n\n> Day advanced. Systems report nominal.",
	"\n\n> Another day passes in silence.",
	"\n\n> Time moves forward, whether you're ready or not..."
]


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
	if not CommandManager.has_command_history or CommandManager.command_history[0] != "skip":
		var msg: String = day_progression_message[randi_range(0, day_progression_message.size() - 1)]
		terminal.print_terminal_output(msg)
	await get_tree().create_timer(3).timeout
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
	SystemManager.day += 1

func _show_game_over_screen() -> void:
	var power_color = "red" if SystemManager.power <= 0 else "white"
	var oxygen_color = "red" if SystemManager.oxygen <= 0 else "white"
	var food_color = "red" if SystemManager.food <= 0 else "white"
	var game_over_art = [
		"\n[ !! SYSTEM FAILURE !! ]",
		"",
		"CRITICAL SYSTEMS OFFLINE",
		"",
		"# PWR: " + SystemManager.get_percent_to_bar(SystemManager.power, 100, 20, power_color),
		"# OXY: " + SystemManager.get_percent_to_bar(SystemManager.oxygen, 100, 20, oxygen_color),
		"# FOD: " + SystemManager.get_percent_to_bar(SystemManager.food, 100, 20, food_color),
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
