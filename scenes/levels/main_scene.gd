extends Control

@export var background_songs: Array[AudioStream]

@onready var background_player: AudioStreamPlayer2D = $BackgroundPlayer

func _ready() -> void:
	_play_next()


func _play_next() -> void:
	var next_song = background_player.stream
	while next_song == background_player.stream:
		next_song = background_songs.pick_random()
	
	background_player.stream = next_song
	background_player.play()


func _on_background_player_finished() -> void:
	_play_next()
