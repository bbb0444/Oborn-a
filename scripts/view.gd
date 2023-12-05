extends Node3D

@export_group("Properties")
@export var target: Node

@export_group("Camera")
@export var zoom_default = 0
@export var zoom_maximum = 5
@export var zoom_speed = 1
@export var x_offset = 0
@export var y_offset = 1
@export var aiming_offset = .5 # How much the camera should to the right (x axis)

@export_group("Rotation")
@export var rotation_speed = 120
@export var mouse_sensitivity = 0.1

var camera_rotation:Vector3
var camera_offset = Vector3(x_offset, y_offset, 0)
var zoom = zoom_default

@onready var camera = %Camera

var aiming = false

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	
	pass

func _physics_process(delta):
	
	# Set position and rotation to targets
	
	#self.position = self.position.lerp(target.position, delta * 4)
	self.position = target.position

	#rotation_degrees = rotation_degrees.lerp(camera_rotation, delta * 6)
	rotation_degrees = camera_rotation


	camera.position = camera.position.lerp(Vector3(0,0,zoom) + camera_offset, 50 * delta)
	
	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta
	#camera_rotation.x = clamp(camera_rotation.x, -80, -10)
	
	# Zooming
	
	if aiming:
		zoom -= zoom_default 
		camera_offset.x = aiming_offset
	else:
		zoom += zoom_maximum 
		camera_offset.x = x_offset

	zoom = clamp(zoom, zoom_maximum, zoom_default)
		



func _input(event):
	if event is InputEventMouseMotion:
		var mouse_delta = Vector2(event.relative.x, event.relative.y) * mouse_sensitivity # mouse vector since last frame
		camera_rotation.y -= mouse_delta.x
		camera_rotation.x = clamp(camera_rotation.x - mouse_delta.y, -80, 80)
	
	if event.is_action_pressed("aim"):
		aiming = true
	if event.is_action_released("aim"):
		aiming = false
	
