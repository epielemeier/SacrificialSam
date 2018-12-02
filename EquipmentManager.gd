extends Node

signal change_sprite

var has_belt = true
var has_boots = true
var has_cape = true
var has_s = true
var has_suit = true

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func lose_equipment(equipment):
	var new_file = "res://art/hero_"
	match equipment:
		"Belt":
			has_belt = false
			new_file += "give_belt"
		"Boots":
			has_boots = false
			new_file += "give_boots"
		"Cape":
			has_cape = false
			new_file += "give_cape"
		"S":
			has_s = false
			new_file += "give_s"
		"Suit":
			has_suit = false
			new_file += "give_suit"
	emit_signal("change_sprite", new_file + ".png")