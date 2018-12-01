extends Node2D


func _ready():
	for child in get_children():
		child.connect("body_entered", get_node("../Hero"), "_on_Spikes_body_entered")
