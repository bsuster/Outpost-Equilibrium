extends Node2D

signal intro_done

@onready var terminal: Terminal = $"../Terminal"
@onready var timer: Timer = $SpacingTimer

var intro_text_blocks: Array[String] = [
	"[BOOTING TERMINAL INTERFACE…]",
	"\n[LOADING COLONY MANAGEMENT SYSTEM v3.42]",
	"\n[USER IDENTIFIED: SYSTEMS OPERATOR - \"COMMANDER\"]",
	"\n[STATUS: CRITICAL | CONNECTION: LOST]\n────────────────────────────────────────────────────────",
	"\n\n> YEAR: 2187  
>> LOCATION: OUTPOST EOS — Epsilon Eridani b  
>> DISTANCE TO EARTH: 10.5 light years",
	"\n\n> Log Entry 0001:
> For 187 days, the colony operated under strict Earth regulation.  
> Supply drops. Engineering updates. Constant contact.  
>  ",
	"
> Then, silence.",

"\n\n>> ALL CONNECTIONS TO EARTH: TERMINATED  
>> LAST MESSAGE: UNREADABLE | SIGNAL LOSS UNKNOWN  
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

>> INTERFACE ACTIVE – COMMAND LINE MODE ENGAGED  
>> Use `help` to view available commands  
>> Use `status` to view current system levels  
>> Type `next` to begin Day 1

────────────────────────────────────────────────────────",
"
> YOU ARE THE FINAL LINE. BALANCE IS SURVIVAL.",
"
> GOOD LUCK, COMMANDER."
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
			intro_done.emit()
			queue_free.call_deferred()
			return
		timer.start(2)
		await timer.timeout
	
	intro_done.emit()
	queue_free.call_deferred()
	

func _input(event):
	if event.is_action_pressed("skip"):
		timer.timeout.emit()
		is_intro_canceled = true
		terminal.force_print_stop()
