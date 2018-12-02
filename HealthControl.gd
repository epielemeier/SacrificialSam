extends HBoxContainer

signal zero_health

var health_amount = 3
var cur_waterbreathing_amount = 0
var is_holding_breath = false

func _ready():
	_set_health(health_amount)
	set_max_health(health_amount)
	$HoldBreathTimer.connect("timeout", self, "_on_HoldBreathTimer_timeout")

func _process(delta):
	if is_holding_breath:
		if $HoldBreathTimer.is_stopped():
			$HoldBreathTimer.start()
		_get_cur_waterbreathing_heart().set_water_progress($HoldBreathTimer.wait_time - $HoldBreathTimer.time_left)

func _get_heart_controls():
	return [$HeartControl,$HeartControl2,$HeartControl3]

func _get_cur_waterbreathing_heart():
	return _get_heart_controls()[max(round(health_amount) - 1, 0)]

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
	if health_amount <= 0:
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



func set_is_holding_breath(boolean):
	var cur_heart = _get_cur_waterbreathing_heart()
	is_holding_breath = boolean
	cur_heart.set_water_progress(0)
	cur_waterbreathing_amount = 0
	if !is_holding_breath:
		$HoldBreathTimer.stop()

func _on_HoldBreathTimer_timeout():
	_get_cur_waterbreathing_heart().set_water_progress(0)
	cur_waterbreathing_amount += 1
	$HoldBreathTimer.stop()
	change_health(-1)