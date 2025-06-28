# SCRIPT FOR CHARACTER CONTROLLER
# MANAGES THE PLAYER
# DEFINES MOVEMENT PARAMETERS AND HANDLES SHOOTING

extends CharacterBody3D

var speed # represents current applied speed

# CONSTANTS
const WALK_SPEED = 2.0
const SPRINT_SPEED = 3.0
const JUMP_VELOCITY = 3.7
const SENSITIVITY = 0.003
var DEADZONE = 0.2

# VIEW BOBBING
const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

# FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 6.5

var PosBullet = load("res://Scenes/PosBullet.tscn") # Reference to Pos projectile
var NegBullet = load("res://Scenes/NegBullet.tscn") # Reference to Neg projectile
var instance

@onready var head = $Head # Reference to Player head
@onready var camera = $Head/Camera3D # Reference to camera
@onready var gun_anim = $Head/Camera3D/gun/RootNode/AnimationPlayer # Reference to gun animator
@onready var gun_barrel = $Head/Camera3D/gun/RootNode/RayCast3D # Reference to gun ray; used for firing projectiles

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED) # use cursor input
	
func _unhandled_input(event):
	if event is InputEventMouseMotion: # When cursor is moved, move camera accordingly
		head.rotate_y(-event.relative.x * SENSITIVITY) 
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60)) # Camera cannot be rotated past 90 degrees up and 60 down.

func _physics_process(delta: float) -> void:
	# Right-stick Camera Rotation.
	var look_x = Input.get_joy_axis(0, JOY_AXIS_RIGHT_X)
	var look_y = Input.get_joy_axis(0, JOY_AXIS_RIGHT_Y)
	if abs(look_x) > DEADZONE:
		head.rotate_y(-look_x * SENSITIVITY * 25) 
	if abs(look_y) > DEADZONE:
		camera.rotate_x(-look_y * SENSITIVITY * 25)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Handle sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED

	var input_dir := Input.get_vector("left", "right", "up", "down") # Creates a vector for movement based off digital inputs
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor(): # Allow movement when on floor
		# Move if direction is applied, otherwise slowdown.
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else: 
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0) 
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0) 
	else: # Slow horizontal movement when falling
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.0) 
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.0) 

	# head bobbing
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	
	# FOV
	var velocity_clamped = clamp(velocity.length(), 0.5, SPRINT_SPEED * 2)
	var target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	camera.fov = lerp(camera.fov, target_fov, delta * 8.0)
	
	# Shooting
	if Input.is_action_pressed("PosShoot"): 
		# Fires 'Pos' projectile only if one is not currently being fire
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = PosBullet.instantiate() # Creates the projectile
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
	# Shooting
	if Input.is_action_pressed("NegShoot"):
		# Fires 'Neg' projectile only if one is not currently being fired
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = NegBullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)

	move_and_slide() # Perform movement
	
func _headbob(time) -> Vector3: # Calculate headbob movement with sin/cos
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
