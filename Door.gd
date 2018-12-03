extends StaticBody2D

func ready():
	close()

func close():
	$DoorTween.interpolate_property($TextureProgress, "value",
		$TextureProgress.value, 100, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DoorTween.start()
	$CollisionShape2D.disabled = false

func open():
	$DoorTween.interpolate_property($TextureProgress, "value",
		$TextureProgress.value, 20, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DoorTween.start()
	$CollisionShape2D.disabled = true

func open_no_tween():
	$TextureProgress.value = 20
	$CollisionShape2D.disabled = true