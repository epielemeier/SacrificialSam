extends Area2D

export (PackedScene) var level

signal next_level

func _ready():
	self.connect("body_entered", self, "_on_body_entered")
	pass

func _on_body_entered(body):
	emit_signal("next_level", level)