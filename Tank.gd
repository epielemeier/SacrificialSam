extends KinematicBody2D

var target
var can_shoot = false

func _ready():
	$Visibility.connect("body_entered", self, "_on_Visibility_body_entered")

func _process(delta):
	if target:
		$Sprite/HeadSprite.rotation = (target.position - position).angle()
		print($Sprite/HeadSprite.rotation)
		if can_shoot:
			shoot(target.position)

func shoot(pos):
	pass


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body

func _on_Visibility_body_exited(body):
	if body == target:
		target = null