extends KinematicBody2D

export (PackedScene) var Bullet

var target
var can_shoot = true

func _ready():
	$Visibility.connect("body_entered", self, "_on_Visibility_body_entered")
	$Visibility.connect("body_exited", self, "_on_Visibility_body_exited")
	$ShootTimer.connect("timeout", self, "_on_ShootTimer_timeout")

func _process(delta):
	if target:
		rotate_head((target.position - position).angle())
		if can_shoot:
			shoot(target.position)

func shoot(pos):
	var b = Bullet.instance()
	var a = (pos - global_position).angle()
	var offset = $Sprite/HeadSprite.position + Vector2(10,5)
	b.start($Sprite/HeadSprite.to_global(offset), a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

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

func _on_ShootTimer_timeout():
	can_shoot = true