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
	#var rot_speed = 2*PI #rotation speed in degrees per second
	#var angle_diff = abs($Sprite/HeadSprite.rotation - new_rotation)
	#if 2*PI - $Sprite/HeadSprite.rotation > PI && 2*PI - new_rotation < PI:
	#	new_rotation += 2*PI
	#if angle_diff != 0:
	#	var time_to_turn = abs(new_rotation / rot_speed)
	#	
	#	$RotationTween.interpolate_property($Sprite/HeadSprite,"rotation",
	#		$Sprite/HeadSprite.rotation,
	#		new_rotation,
	#		time_to_turn,
	#		Tween.TRANS_QUAD,
	#		Tween.EASE_OUT_IN)
	#	$RotationTween.start()


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	rotate_head((target.position - position).angle())

func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		#$RotationTween.stop($Sprite/HeadSprite)