extends Control

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	set_full_heart()

func set_full_heart():
	$FullTexture.visible = true
	$HalfTexture.visible = false
	$EmptyTexture.visible = false

func set_half_heart():
	$FullTexture.visible = false
	$HalfTexture.visible = true
	$EmptyTexture.visible = false

func set_empty_heart():
	$FullTexture.visible = false
	$HalfTexture.visible = false
	$EmptyTexture.visible = true
