extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	for child in $Spikes.get_children():
		child.connect("body_entered", self, "_on_Spikes_body_entered")
	$Tank.connect("bullet_hit", self, "_on_Bullet_hit")
	$HealthControl.connect("zero_health", self, "_on_HealthControl_zero_health")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Spikes_body_entered(body):
	if body == $Hero:
		$HealthControl.change_health(-$HealthControl.get_health())

func _on_Bullet_hit(body):
	if body == $Hero:
		$HealthControl.change_health(-0.5)

func _on_HealthControl_zero_health():
	get_tree().reload_current_scene()
