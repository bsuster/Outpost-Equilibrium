extends Node2D

signal intro_done

@onready var terminal: Terminal = $"../Terminal"
@onready var timer: Timer = $SpacingTimer

var intro_text_blocks: Array[String] = [
	"[BOOTING TERMINAL INTERFACE…]",
	"\n[LOADING COLONY MANAGEMENT SYSTEM v3.42]",
	"\n[USER IDENTIFIED: SYSTEMS OPERATOR - \"[color=green]COMMANDER[/color]\"]",
	"\n[STATUS: [color=red]CRITICAL[/color] | CONNECTION: [color=red]LOST[/color]]\n────────────────────────────────────────────────────────",
	"\n\n> YEAR: [color=blue]2187[/color]  
>> LOCATION: [color=blue]OUTPOST EOS — Epsilon Eridani b[/color]  
>> DISTANCE TO EARTH: 10.5 light years",
	"\n\n> Log Entry [color=blue]00117[/color]:
> For 187 days, the colony operated under strict Earth regulation.  
> Supply drops. Engineering updates. Constant contact.  
>  ",
	"
> Then, silence.",

"\n\n>> ALL CONNECTIONS TO EARTH: [color=red]TERMINATED[/color]  
>> LAST MESSAGE: [color=red]UNREADABLE[/color] | SIGNAL LOSS [color=red]UNKNOWN[/color]  
>> MISSION STATUS: ABANDONED",

"\n\n> The settlers look to you now — the last systems operator on site.  
> With no help coming, survival rests on your ability to maintain  
> the colony’s core systems: 

- ATMOSPHERE  
- POWER GRID  
- FOOD STORES   ",

"\n\n> Any system that fails will result in catastrophic loss of life.",

"

────────────────────────────────────────────────────────

>> INTERFACE [color=green]ACTIVE[/color] – COMMAND LINE MODE [color=green]ENGAGED[/color]  
>> Use [color=green]`help`[/color] to view available commands  
>> Use [color=green]`status`[/color] to view current system levels  
>> Type [color=green]`next`[/color] to progress after your decision has been made

────────────────────────────────────────────────────────",
"
> YOU ARE THE FINAL LINE. BALANCE IS SURVIVAL.",
"
> GOOD LUCK, COMMANDER.",
]

var is_intro_canceled: bool = false

func _ready():
	_show_intro()
	#await get_tree().create_timer(2).timeout
	#$Label.visible = true
	#$AnimationPlayer.play("skip_pulse")

func _show_intro() -> void:
	terminal.disable_input()
	for line in intro_text_blocks:
		terminal.print_terminal_output(line)
		await terminal.printing_done
		if is_intro_canceled:
			terminal.print_terminal_output("]")
			await terminal.printing_done
			finish_intro()
			return
		timer.start(3)
		await timer.timeout
	
	finish_intro()

func finish_intro():
	terminal.enable_input()
	intro_done.emit()
	queue_free.call_deferred()
	

func _input(event):
	if event.is_action_pressed("skip"):
		timer.timeout.emit()
		is_intro_canceled = true
		terminal.force_print_stop()
