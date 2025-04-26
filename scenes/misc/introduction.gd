extends Node2D

signal intro_done

@onready var terminal: Terminal = $"../Terminal"
@onready var timer: Timer = $SpacingTimer

var intro_text_blocks: Array[String] = [
	"[BOOTING TERMINAL INTERFACE...]",
	"\n[LOADING COLONY MANAGEMENT SYSTEM v3.42]",
	"\n[USER IDENTIFIED: SYSTEMS OPERATOR - \"[color=green]COMMANDER[/color]\"]",
	"\n[STATUS: [color=red]CRITICAL[/color] | CONNECTION: [color=red]LOST[/color]]\n----------------------------------------------------",
	"\n\n> YEAR: 2187 
>> LOCATION: OUTPOST EOS - Kepler-452b 
>> DISTANCE TO EARTH: 1,800 light years",
	"\n\n> Log Entry [color=green]00117[/color]:
> For 187 days, the colony operated under strict Earth regulation.  
> Supply drops. Engineering updates. Constant contact.  
>  ",
	"
> Then, silence.",

"\n\n>> ALL CONNECTIONS TO EARTH: [color=red]TERMINATED[/color]  
>> LAST MESSAGE: [color=red]UNREADABLE[/color] | SIGNAL LOSS [color=red]UNKNOWN[/color]  
>> MISSION STATUS: [color=red]ABANDONED[/color]",

"\n\n> The settlers look to you now, the last systems operator on site.  
> With no help coming, survival rests on your ability to maintain  
> the colony's core systems: 

- OXYGEN  
- POWER GRID  
- FOOD STORES   ",

"\n\n> Any system that fails will result in catastrophic loss of life.",

"

========================================================

>> INTERFACE [color=green]ACTIVE[/color] - COMMAND LINE MODE [color=green]ENGAGED[/color]  
>> Use [color=green]`help`[/color] to view available commands  
>> Use [color=green]`status`[/color] to view current system levels  
>> Use [color=green]`skip`[/color] to move on to the next day without stabilizing  

- You may issue only [color=red]one command per day[/color].  
- Use the [color=green]UP[/color] and [color=green]DOWN[/color] arrow keys to scroll through previous commands.  

========================================================",
"
> YOU ARE THE FINAL LINE. BALANCE IS SURVIVAL.",
"
> GOOD LUCK, COMMANDER.",
]

var is_intro_canceled: bool = false

func _ready():
	$Label.visible = false
	_show_intro()
	await get_tree().create_timer(10).timeout
	$Label.visible = true
	$AnimationPlayer.play("skip_pulse")

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
