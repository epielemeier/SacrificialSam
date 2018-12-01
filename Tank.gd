extends KinematicBody2D

var target
var can_shoot = false

func _ready():
	$Visibility.connect("body_entered", self, "_on_Visibility_body_entered")
	$Visibility.connect("body_exited", self, "_on_Visibility_body_exited")

func _process(delta):
	if target:
		rotate_head((target.position - position).angle())
		if can_shoot:
			shoot(target.position)

func shoot(pos):
	pass

func rotate_head(new_rotation):
	$Sprite/HeadSprite.rotation = new_rotation


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	rotate_head((target.position - position).angle())

func _on_Visibility_body_exited(body):
	if body == target:
		target = null