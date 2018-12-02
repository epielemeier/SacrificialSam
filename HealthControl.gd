extends HBoxContainer

signal zero_health

var health_amount = 3

func _ready():
	_set_health(health_amount)
	set_max_health(health_amount)

func _get_heart_controls():
	return [$HeartControl,$HeartControl2,$HeartControl3]

func _set_health(amount):
	var h = _get_heart_controls()
	var i = 0
	while amount >= 1:
		h[i].set_full_heart()
		amount -= 1
		i += 1
	if amount == .5:
		h[i].set_half_heart()
		i += 1
	while i < h.size():
		h[i].set_empty_heart()
		i += 1

func change_health(difference):
	health_amount += difference
	_set_health(health_amount)
	if health_amount == 0:
		emit_signal("zero_health")

func get_health():
	return health_amount

func set_max_health(value):
	var h = _get_heart_controls()
	for i in range(min(value, h.size())):
		h[i].visible = true
	for i in range(value, h.size()):
		h[i].visible = false
	health_amount = min(health_amount, value)
