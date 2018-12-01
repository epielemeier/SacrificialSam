extends StaticBody2D

var body_in_interaction_area
var equipment = "Boots"

func _ready():
	$InteractionArea.connect("body_entered", self, "_on_InteractionArea_body_entered")
	$InteractionArea.connect("body_exited", self, "_on_InteractionArea_body_exited")

func is_interacting_with(body):
	return body_in_interaction_area == body

func interact():
	$HelpPopup.ask_for_equipment(equipment)
	$PopupTimer.start()
	yield($PopupTimer, "timeout")
	$HelpPopup.hide()

func _on_InteractionArea_body_entered(body):
	body_in_interaction_area = body

func _on_InteractionArea_body_exited(body):
	body_in_interaction_area = null