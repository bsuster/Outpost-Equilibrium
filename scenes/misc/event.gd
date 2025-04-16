extends Node

class_name Event

var title: String = ""
var description: String = ""
var modifiers: Dictionary

func _init(t, d, m) -> void:
	title = t
	description = d
	modifiers = m
