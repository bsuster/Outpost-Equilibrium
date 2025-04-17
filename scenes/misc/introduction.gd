extends Node

@onready var terminal: Terminal = $"../Terminal"

var intro_text_blocks: Array[String] = [
	"[BOOTING TERMINAL INTERFACE…]",
	"\n[LOADING COLONY MANAGEMENT SYSTEM v3.42]",
	"\n[USER IDENTIFIED: SYSTEMS OPERATOR - \"COMMANDER\"]",
	"\n[STATUS: CRITICAL | CONNECTION: LOST]\n────────────────────────────────────────────────────────",
	"\n\n>> YEAR: 2187  
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

func _ready():
	terminal.disable_input()
	for line in intro_text_blocks:
		terminal.print_terminal_output(line)
		await terminal.printing_done
		await get_tree().create_timer(2).timeout
	
	terminal.enable_input()
	queue_free.call_deferred()
