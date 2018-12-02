extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	for child in $Spikes.get_children():
		child.connect("body_entered", self, "_on_Spikes_body_entered")
	for child in $WaterTiles.get_children():
		child.connect("area_entered", self, "_on_WaterTile_area_entered")
		child.connect("area_exited", self, "_on_WaterTile_area_exited")
	for child in $HeartCollectibles.get_children():
		child.connect("body_entered", self, "_on_HeartCollectible_body_entered", [child])
	$PressurePlate.connect("body_entered", $Door, "open")
	$PressurePlate.connect("body_exited", $Door, "close")
	#$Victim.connect("give_equipment", self, "_on_Victim_give_equipment")
	$Hero.connect("interacting", self, "_on_Hero_interacting")
	$Tank.connect("bullet_hit", self, "_on_Bullet_hit")
	$HealthControl.connect("zero_health", self, "_on_HealthControl_zero_health")


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _on_Spikes_body_entered(body):
	if body == $Hero:
		$HealthControl.change_health(-$HealthControl.get_health())

func _on_WaterTile_area_entered(area):
	if area == $Hero/HeadArea && !$Hero/EquipmentManager.has_belt:
		$HealthControl.set_is_holding_breath(true)

func _on_WaterTile_area_exited(area):
	if area == $Hero/HeadArea:
		$HealthControl.set_is_holding_breath(false)

func _on_Bullet_hit(body):
	if body == $Hero:
		$HealthControl.change_health(-0.5)

func _on_HeartCollectible_body_entered(body, collectible):
	if body == $Hero:
		if $HealthControl.get_health_lost() > 0:
			$HealthControl.change_health(1)
			collectible.queue_free()
			

func _on_HealthControl_zero_health():
	get_tree().reload_current_scene()

func _on_Hero_interacting(hero):
		if $Victim.is_interacting_with(hero):
			$Victim.interact()

func _on_Victim_give_equipment(equipment):
	$Hero/EquipmentManager.lose_equipment(equipment)
	if equipment == "Suit":
		$HealthControl.set_max_health(1)
