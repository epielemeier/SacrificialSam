extends KinematicBody2D

signal interacting
signal start_walk
signal end_walk

# copied and modified from https://github.com/godotengine/godot-demo-projects/blob/master/2d/kinematic_character/player.gd
const SPEEDUP = 2
# Member variables
const GRAVITY = 1000.0 * SPEEDUP # pixels/second/second

# Angle in degrees towards either side that the player can consider "floor"
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 600
const WALK_MIN_SPEED = 50 * SPEEDUP
const WALK_MAX_SPEED = 150 * SPEEDUP
const STOP_FORCE = 1300 * SPEEDUP
const JUMP_SPEED = 300 * SPEEDUP
const JUMP_MAX_AIRBORNE_TIME = 0.2
const DASH_SPEED = 600 * SPEEDUP
const DASH_MAX_TIME = .2
const FLY_GRAVITY = GRAVITY * .25 * SPEEDUP

const SLIDE_STOP_VELOCITY = 1.0 # one pixel/second
const SLIDE_STOP_MIN_TRAVEL = 1.0 # one pixel

var velocity = Vector2()
var on_air_time = 100
var dash_time = 100
var jumping = false
var dashing = false
var flying = false
var shrinking = false

var prev_jump_pressed = false
var prev_dash_pressed = false

var is_facing_left = false

func _physics_process(delta):
	# Create forces
	var force = Vector2(0, GRAVITY)
	if flying:
		force = Vector2(0, FLY_GRAVITY)
	
	var walk_left = Input.is_action_pressed("ui_left")
	var walk_right = Input.is_action_pressed("ui_right")
	var fly_up = Input.is_action_pressed("ui_up") and $EquipmentManager.has_cape
	var fly_down = Input.is_action_pressed("ui_down") and $EquipmentManager.has_cape
	var jump = Input.is_action_pressed("ui_select")
	var dash = !shrinking and Input.is_action_pressed("dash") and $EquipmentManager.has_boots
	var interact = !shrinking and Input.is_action_just_pressed("interact")
	var shrunk = Input.is_action_just_pressed("shrink")
	
	if flying or (!walk_left and !walk_right):
		emit_signal("end_walk", $AnimatedSprite)
	else:
		emit_signal("start_walk", $AnimatedSprite)
	
	var stop = true
	
	if shrunk:
		toggle_shrink()
	if interact:
		emit_signal("interacting", self)

	if walk_left:
		if velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED:
			force.x -= WALK_FORCE
			stop = false
			is_facing_left = true
			$AnimatedSprite.flip_h = true
			if shrinking:
				rotation -= PI/10
			
	elif walk_right:
		if velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED:
			force.x += WALK_FORCE
			stop = false
			is_facing_left = false
			$AnimatedSprite.flip_h = false
			if shrinking:
				rotation += PI/10
	
	if jumping:
		if fly_up:
			if velocity.y <= WALK_MIN_SPEED and velocity.y > -WALK_MAX_SPEED:
				velocity.y -= WALK_MIN_SPEED
				stop = false
		elif fly_down:
			if velocity.y >= -WALK_MIN_SPEED and velocity.y < WALK_MAX_SPEED:
				velocity.y += WALK_MIN_SPEED
				stop = false

	
	if dashing:
		if dash_time > DASH_MAX_TIME:
			dashing = false
			dash_time = 0
			stop = true
			if is_facing_left:
				velocity.x = -WALK_MAX_SPEED
			else:
				velocity.x = WALK_MAX_SPEED
			velocity.y = GRAVITY
		else:
			dash_time += delta
	
	if stop:
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		
		vlen -= STOP_FORCE * delta
		if vlen < 0:
			vlen = 0
		
		velocity.x = vlen * vsign
	
	# Integrate forces to velocity
	velocity += force * delta
	# Integrate velocity into motion and move
	velocity = move_and_slide(velocity, Vector2(0, -1))
	
	if is_on_floor():
		on_air_time = 0
		flying = false
		
	if jumping and velocity.y > 0:
		# If falling, no longer jumping
		jumping = false
	
	if jump and not prev_jump_pressed and jumping and not flying and not shrinking:
		flying = true
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and jump and not prev_jump_pressed and not jumping:
		# Jump must also be allowed to happen if the character left the floor a little bit ago.
		# Makes controls more snappy.
		velocity.y = -JUMP_SPEED
		jumping = true
	
	
	if on_air_time < JUMP_MAX_AIRBORNE_TIME and dash and not prev_dash_pressed and not dashing:
		if walk_left:
			velocity.x = -(DASH_SPEED*cos(PI/24))
		elif walk_right:
			velocity.x = DASH_SPEED*cos(PI/24)
		if walk_left or walk_right:
			velocity.y = 0-DASH_SPEED*sin(PI/24)
		dashing = true
		dash_time = 0

	
	on_air_time += delta
	prev_jump_pressed = jump
	prev_dash_pressed = dash

func _ready():
	$EquipmentManager.connect("change_sprite", self, "_on_EquipmentManager_change_sprite")
	self.connect("start_walk", $EquipmentManager, "_on_Hero_start_walk")
	self.connect("end_walk", $EquipmentManager, "_on_Hero_end_walk")

func toggle_shrink():
	shrinking = !shrinking
	$ShrinkSprite.visible = shrinking
	$AnimatedSprite.visible = !shrinking
	$ShrinkCollisionShape2D.disabled = !shrinking
	$CollisionShape2D.disabled = shrinking
	rotation = 0.0


func _on_EquipmentManager_change_sprite(texture):
	$AnimatedSprite.frames.add_frame("default", texture)
	$AnimatedSprite.frame += 1
	$AnimatedSprite.frames.remove_frame("default", 0)
