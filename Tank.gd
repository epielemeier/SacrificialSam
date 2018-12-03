extends KinematicBody2D

export (PackedScene) var Bullet
export (int) var starting_head_rotation_degrees = 0
export (float) var visibility_modifier = 1
export (float) var shoot_wait_time = 1

signal bullet_hit

var target
var can_shoot = true

func _ready():
	$Visibility.connect("body_entered", self, "_on_Visibility_body_entered")
	$Visibility.connect("body_exited", self, "_on_Visibility_body_exited")
	$ShootTimer.connect("timeout", self, "_on_ShootTimer_timeout")
	rotate_head(deg2rad(starting_head_rotation_degrees))
	$Visibility.scale *= visibility_modifier
	$ShootTimer.wait_time = shoot_wait_time

func _physics_process(delta):
	if target:
		aim()

func aim():
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(position, target.position,
		[self], collision_mask)
	if result:
		var hit_pos = result.position
		if result.collider == target:
			rotate_head((target.position - position).angle())
			if can_shoot:
				shoot(target.position)


func shoot(pos):
	var b = Bullet.instance()
	b.connect("body_entered", self, "_on_Bullet_body_entered")
	var a = (pos - global_position).angle()
	var offset = $Sprite/HeadSprite.position + Vector2(10,5)
	b.start($Sprite/HeadSprite.to_global(offset), a + rand_range(-0.05, 0.05))
	get_parent().add_child(b)
	can_shoot = false
	$ShootAudio.play()
	$ShootTimer.start()

func rotate_head(new_rotation):
	$Sprite/HeadSprite.rotation = new_rotation


func _on_Visibility_body_entered(body):
	if target:
		return
	target = body
	rotate_head((target.position - position).angle())
	if $ShootTimer.is_stopped():
		$ShootTimer.start()

func _on_Visibility_body_exited(body):
	if body == target:
		target = null
		$ShootTimer.stop()

func _on_ShootTimer_timeout():
	can_shoot = true

func _on_Bullet_body_entered(body):
	emit_signal("bullet_hit", body)