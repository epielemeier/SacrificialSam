extends Node

signal change_sprite

var has_belt = true
var has_boots = true
var has_cape = true
var has_s = true
var has_suit = true

var give_belt_texture = preload("res://art/hero_give_belt.png")
var give_boots_texture = preload("res://art/hero_give_boots.png")
var give_cape_texture = preload("res://art/hero_give_cape.png")
var give_s_texture = preload("res://art/hero_give_s.png")
var give_suit_texture = preload("res://art/hero_give_suit.png")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass
	
func _on_Hero_end_walk(animated_sprite):
	animated_sprite.animation = "default"

func _on_Hero_start_walk(animated_sprite):
	animated_sprite.animation = "walk"
	animated_sprite.play()

func lose_equipment(equipment):
	var new_file = null
	match equipment:
		"Belt":
			has_belt = false
			new_file = give_belt_texture
		"Boots":
			has_boots = false
			new_file = give_boots_texture
		"Cape":
			has_cape = false
			new_file = give_cape_texture
		"S":
			has_s = false
			new_file = give_s_texture
		"Suit":
			has_suit = false
			new_file = give_suit_texture
	emit_signal("change_sprite", new_file)