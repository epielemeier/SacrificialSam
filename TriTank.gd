extends KinematicBody2D

export (PackedScene) var Bullet

signal bullet_hit

var target
var can_shoot = true

func _ready():
	$ShootTimer.connect("timeout", self, "_on_ShootTimer_timeout")

func _process(delta):
	if can_shoot:
		shoot_every_head()

func shoot_every_head():
	shoot($Sprite/HeadSprite1,
		Vector2(position.x - 1000, position.y), Vector2(-.01,-1))
	shoot($Sprite/HeadSprite2,
		Vector2(position.x, position.y - 1000), Vector2(2,1))
	shoot($Sprite/HeadSprite3,
		Vector2(position.x + 1000, position.y), Vector2(.01,-1))
	can_shoot = false
	$ShootTimer.start()

func shoot(head_sprite, pos, off):
	var b = Bullet.instance()
	b.connect("body_entered", self, "_on_Bullet_body_entered")
	var a = (pos - global_position).angle()
	var offset = head_sprite.position + Vector2(5,5) * off
	b.start(head_sprite.to_global(offset), a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootTimer.start()

func _on_ShootTimer_timeout():
	can_shoot = true

func _on_Bullet_body_entered(body):
	emit_signal("bullet_hit", body)