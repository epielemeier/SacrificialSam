extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	for child in $Spikes.get_children():
		child.connect("body_entered", self, "_on_Spikes_body_entered")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Spikes_body_entered(body):
	if body == $Hero:
		get_tree().reload_current_scene()
