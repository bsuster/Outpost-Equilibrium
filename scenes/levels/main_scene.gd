extends Camera2D

@export var background_songs: Array[AudioStream]

@onready var terminal: Terminal = $CanvasLayer/Terminal
@onready var background_player: AudioStreamPlayer2D = $CanvasLayer/BackgroundPlayer
@onready var glitch_effect: ColorRect = $CanvasLayer/GlitchEffect

var day_progression_message: Array[String] = [
	"\n\n> Day advanced. Systems report nominal.",
	"\n\n> Another day passes in silence.",
	"\n\n> Time moves forward, whether you're ready or not..."
]


func _ready() -> void:
	glitch_effect.visible = false
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
	glitch_effect.visible = false
	terminal.disable_input()
	await get_tree().create_timer(1).timeout
	if terminal.is_printing:
		await terminal.printing_done
	await get_tree().create_timer(2).timeout
	if not CommandManager.has_command_history or CommandManager.command_history[0] != "skip":
		var msg: String = day_progression_message[randi_range(0, day_progression_message.size() - 1)]
		terminal.print_terminal_output(msg)
		await terminal.printing_done
	EventManager.refresh_active_events()
	if EventManager.is_updating_events:
		await EventManager.active_events_updated
	await get_tree().create_timer(1).timeout
	if terminal.is_printing:
		await terminal.printing_done
	var day_string = "\nDay: %s" % [SystemManager.day]
	terminal.print_terminal_output(day_string)
	await terminal.printing_done
	terminal.print_terminal_output(CommandManager.get_status_message())
	await terminal.printing_done
	if SystemManager.is_game_over:
		_show_game_over_screen()
		return
	SystemManager.set_can_advance_day(false)
	terminal.enable_input()
#
func _on_intro_done():
	SystemManager.day += 1

func _show_game_over_screen() -> void:
	glitch_effect.visible = true
	
	var game_over_art = [
		"\n[ !! SYSTEM FAILURE !! ]",
		"",
		"CRITICAL SYSTEMS OFFLINE",
		"",
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
		"   Type '[color=green]restart[/color]' to begin again.\n"
	]

	for line in game_over_art:
		terminal.print_terminal_output(line)
		await terminal.printing_done

	SystemManager.set_can_advance_day(false)
	terminal.enable_input() # Enable terminal for 'restart'
