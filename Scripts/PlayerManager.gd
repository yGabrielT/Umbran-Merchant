extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01

#bob variables
const BOB_FREQ = 2.4
const BOB_AMP = 0.05
var t_bob = 0.0 
var idle_bob = 0.0
var cos_value = 2.0
var velocity_valuer = 0.0

#Raycast
var raycastObj : Node3D = null
var isLookingToItem = false


#raycast
@onready var raycaster : RayCast3D = $Head/Camera3D/RayCast3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var head = $Head
@onready var camera = $Head/Camera3D


func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _input(event):
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
#region Player Movement

	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0.0
		velocity.z = 0.0
#endregion
	
#region HeadBob
	# Head bob
	
	
	if velocity.length() == 0.0:
		cos_value = lerp(cos_value, 0.0, delta * 10)
		velocity_valuer = .5
	else:
		cos_value = lerp(cos_value, .5, delta * 10)
		velocity_valuer = velocity.length()
		
	t_bob += delta * velocity_valuer * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)

	move_and_slide()
#endregion
	
	if raycaster.is_colliding():
		raycastObj = raycaster.get_collider().get_node("Outliner")
		raycastObj.visible = true;
		isLookingToItem = true
	else:
		if raycastObj != null:
			raycastObj.visible = false;
			isLookingToItem = false
	
	

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * (BOB_AMP * cos_value)
	return pos
		
