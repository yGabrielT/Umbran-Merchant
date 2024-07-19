extends Node3D

const SENSITIVITY = 0.03

@onready var head = $Head
@onready var camera = $Head/Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
