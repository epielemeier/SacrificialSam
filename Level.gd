extends Node

var victim = null

func _ready():
	register_health_control($HealthControl)
	register_hero($Hero)
	register_gate($Gate)
	register_water_tiles($WaterTiles.get_children())
	register_spikes($Spikes.get_children())
	register_tanks($Tanks.get_children())
	register_heart_collectibles($HeartCollectibles.get_children())
	#register_pressure_plate_and_door($PressurePlate, $Door)
	if get_node("Victim") != null:
		register_victim($Victim)

func register_spikes(spike_list):
	for n in spike_list:
		n.connect("body_entered", self, "_on_Spikes_body_entered")

func register_water_tiles(water_tile_list):
	for n in water_tile_list:
		n.connect("area_entered", self, "_on_WaterTile_area_entered")
		n.connect("area_exited", self, "_on_WaterTile_area_exited")

func register_heart_collectibles(heart_collectible_list):
	for n in heart_collectible_list:
		n.connect("body_entered", self, "_on_HeartCollectible_body_entered", [n])

func register_pressure_plate_and_door(pressure_plate, door):
	pressure_plate.connect("is_pressed", door, "open")
	pressure_plate.connect("is_not_pressed", door, "close")

func register_victim(v):
	v.connect("give_equipment", self, "_on_Victim_give_equipment")
	victim = v

func register_hero(hero):
	hero.connect("interacting", self, "_on_Hero_interacting")

func register_tanks(tank_list):
	for n in tank_list:
		n.connect("bullet_hit", self, "_on_Bullet_hit")

func register_health_control(health_control):
	health_control.connect("zero_health", self, "_on_HealthControl_zero_health")

func register_gate(gate):
	gate.connect("next_level", self, "_on_Gate_next_level")

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
		if victim != null and victim.is_interacting_with(hero):
			victim.interact()

func _on_Victim_give_equipment(equipment):
	$Hero/EquipmentManager.lose_equipment(equipment)
	if equipment == "Suit":
		$HealthControl.set_max_health(1)

func _on_Gate_next_level(level):
	var t = get_tree()
	t.change_scene_to(level)
	queue_free()
