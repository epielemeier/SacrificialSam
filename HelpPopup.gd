extends Control

var equipment = ["Belt", "Boots", "Cape", "S", "Suit"]

func _ready():
	for e in equipment:
		_hide_texture(e)
	visible = false

func _hide_texture(e):
	get_node(e + "Texture").visible = false
func _show_texture(e):
	get_node(e + "Texture").visible = true

func ask_for_equipment(equipment_name):
	_show_texture(equipment_name)
	visible = true