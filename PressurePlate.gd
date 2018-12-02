extends Area2D

signal is_pressed
signal is_not_pressed

var body_count = 0

func _ready():
	self.connect("body_entered", self, "on_body_entered")
	self.connect("body_exited", self, "on_body_exited")

func on_body_entered(body):
	body_count += 1
	if body_count == 1:
		emit_signal("is_pressed")

func on_body_exited(body):
	body_count -= 1
	if body_count == 0:
		emit_signal("is_not_pressed")

