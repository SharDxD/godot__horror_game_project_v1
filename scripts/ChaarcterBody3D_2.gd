extends CharacterBody3D


const SPEED = 7.0
const CROUCHSPEED = 1.5
const JUMP_VELOCITY = 4.5
var crouched : bool
var flash : bool

@onready var ray_cast: RayCast3D = $Camera3D/RayCast3D
@onready var interaction_label: Label = $CenterContainer/Label
@onready var pause_menu: Control = $Pause

var gravity = 10
var mouse_sensitivity = 0.001
var camera_rotation_limit = 70.0
var paused = false

func pauseMenu():
	if paused:
		pause_menu.hide()
		get_tree().paused = false
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		Engine.time_scale = 1
	else:
		pause_menu.show()
		get_tree().paused = true
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		Engine.time_scale = 0
	paused = !paused
	#if paused:
		#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		#pause_menu.hide()
		#get_tree().paused = false
#
	#else:
		#Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		#get_tree().paused = true
		#pause_menu.show()



func _ready():
	ray_cast.add_exception(self)
	
func _process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	if ray_cast.is_colliding():
		if not interaction_label.visible:
			interaction_label.visible = true
	else:
		if interaction_label.visible:
			interaction_label.visible = false

func _rotate_player_and_camera(relative_motion):
	# Rotate player left/right
	rotation.y -= relative_motion.x * mouse_sensitivity

	# Get current camera rotation
	var camera_rotation = $Camera3D.rotation_degrees
	# Rotate camera up/down
	camera_rotation.x -= relative_motion.y * 100 * mouse_sensitivity
	# Clamp the camera's vertical rotation
	camera_rotation.x = clamp(camera_rotation.x, -camera_rotation_limit, camera_rotation_limit)
	$Camera3D.rotation_degrees = camera_rotation

func _input(event):
	if event.is_action_pressed("Interact") and ray_cast.is_colliding():
		if ray_cast.get_collider() is InteractionBase:
			ray_cast.get_collider().interact()

	if event is InputEventMouseMotion:
		_rotate_player_and_camera(event.relative)

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var speed = SPEED
	if Input.is_action_pressed("crouch"):
		speed = CROUCHSPEED
		if !crouched:
			$AnimationPlayer.play("crouch")
			crouched = true
	else:
		if crouched:
			var space_state = get_world_3d().direct_space_state
			var result = space_state.intersect_ray(PhysicsRayQueryParameters3D.create(position, position + Vector3(0,2,0), 1, [self]))
			if result.size() == 0:
				$AnimationPlayer.play("uncrouch")
				crouched = false
				
	if Input.is_action_just_pressed("flashlight"):
		if flash:
			$AnimationPlayer.play("flashlight_v2")
		else:
			$AnimationPlayer.play("flashlight_v2_reverse")
		flash = !flash
		
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
