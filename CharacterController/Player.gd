extends CharacterBody3D


@export var SPEED = 10
@export var ACCELERATION = 2
@export var JUMP_VELOCITY = 4.5
@export var SENSITIVITY = 1

# get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# the walking direction of the player
@export var vel = Vector3.ZERO

# get the camera of the player
@onready var head = $Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# rotate the camera
func _input(event):
	# get mouse input for camera rotation
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * SENSITIVITY))
		head.rotate_x(deg_to_rad(-event.relative.y * SENSITIVITY))
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-89), deg_to_rad(89))

# runs every frame
func _physics_process(delta):
	# get player input
	var direction = Vector3.ZERO
	var h_rot = global_transform.basis.get_euler().y
	var f_input = Input.get_action_strength("s_key") - Input.get_action_strength("w_key")
	var h_input = Input.get_action_strength("d_key") - Input.get_action_strength("a_key")
	direction = Vector3(h_input, 0, f_input).rotated(Vector3.UP, h_rot).normalized()
	
	# add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
		
	# make speeding up smoother
	vel.x = lerpf(vel.x,direction.x * SPEED, delta * ACCELERATION)
	vel.z = lerpf(vel.z,direction.z * SPEED, delta * ACCELERATION)
	# make sure the player can never go too fast
	vel.x = clampf(vel.x, -SPEED, SPEED)
	vel.z = clampf(vel.z, -SPEED, SPEED)
	
	if is_on_floor():
		# to jump
		if Input.is_action_just_pressed("spacebar"):
			velocity.y = JUMP_VELOCITY * 2
		
		# drag/friction to slow player down
		vel.x = lerpf(vel.x, 0, delta * SPEED/2)
		vel.z = lerpf(vel.z, 0, delta * SPEED/2)
		
		# make the player move
		velocity.x = vel.x * 10
		velocity.z = vel.z * 10
	
	# apply the movement changes
	move_and_slide()
