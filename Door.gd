extends StaticBody2D

func ready():
	close(null)

func close(body):
	$DoorTween.interpolate_property($TextureProgress, "value",
		$TextureProgress.value, 100, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DoorTween.start()
	$CollisionShape2D.disabled = false

func open(body):
	$DoorTween.interpolate_property($TextureProgress, "value",
		$TextureProgress.value, 20, 1,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$DoorTween.start()
	$CollisionShape2D.disabled = true