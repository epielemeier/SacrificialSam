extends RigidBody2D

var force = 700

func _ready():
	set_contact_monitor(true)
	set_max_contacts_reported(5)
	self.connect("body_entered", self, "_on_Bullet_body_entered")

func start(pos, dir):
	position = pos
	rotation = dir
	apply_impulse(Vector2(1,0), Vector2(cos(dir), sin(dir)) * force)

func _on_Bullet_body_entered(body):
	queue_free()