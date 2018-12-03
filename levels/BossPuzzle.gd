extends Node

export (PackedScene) var HappyVictim

func _ready():
	get_node("../PressurePlate").connect("body_entered", self, "_on_PressurePlate_body_entered")
	get_node("../Door1").open()
	get_node("../Door2").open()

func _on_PressurePlate_body_entered(body):
	get_node("../Door1").close()
	get_node("../Door2").close()
	for plate in [$PressurePlate_cape, $PressurePlate_boots, $PressurePlate_belt, $PressurePlate_s, $PressurePlate_suit]:
		var v = HappyVictim.instance()
		v.position = plate.position - Vector2(0,25)
		get_parent().add_child(v)