extends Node3D

@onready var arm = %SpringArm3D
@onready var camera = %Camera
@onready var player = %Player
@onready var view = %View
@onready var camera_root_offset = %RootOffset
@onready var camera_leaf_offset = %LeafOffset

@onready var camera_root_pos = camera_root_offset.position

@export_group("Properties")
@export var target: Node

@export_group("Rotation")
@export var rotation_speed = 120
@export var mouse_sensitivity = 0.05
@export var lerp_weight = 10

@export_group("Camera")
@export var zoom_maximum = 0.0
@export var zoom_speed = 1
@export var x_offset = 0
@export var y_offset = 0
@export var z_offset = 0
@export var aiming_offset = 2 # How much the camera should to the right (x axis)

var zoom_default = 8.0 #arm.spring_length
var zoom = zoom_default
var camera_rotation:Vector3

var aiming = false

var offset = Vector3(x_offset, y_offset, z_offset)

var camera_x_rot_clamp = -80.0
var camera_y_rot_clamp = 0.0

var mouse_delta = Vector2.ZERO

signal Aiming(aiming)

func _ready():
	
	camera_rotation = rotation_degrees # Initial rotation
	GlobalSignals.add_emitter("Aiming", self)
	
	pass

func _physics_process(delta):
	
	# Set position and rotation to targets
	
	arm.rotation_degrees = camera_rotation
	view.position = target.position

	#camera.position = camera.position.lerp(offset, lerp_weight * delta)
	#view.position = target.position.lerp(target.position + offset, 50*delta)
	#camera.position = camera.position.lerp(Vector3(0,0,zoom) + offset, 50 * delta)
	#var weight = lerp(zoom_default, zoom_maximum, zoom)
	# camera_leaf_offset.global_transform.origin = camera_leaf_offset.global_transform.origin.lerp(Vector3(0,0,zoom) + offset, 0.1)

	handle_input(delta)

# Handle input

func handle_input(delta):
	
	# Rotation
	
	var input := Vector3.ZERO
	
	input.y = Input.get_axis("camera_left", "camera_right")
	input.x = Input.get_axis("camera_up", "camera_down")
	
	camera_rotation += input.limit_length(1.0) * rotation_speed * delta # Rotate camera consistently

	camera_rotation.y -= mouse_delta.x
	camera_rotation.x = clamp(camera_rotation.x - mouse_delta.y, camera_x_rot_clamp, camera_y_rot_clamp)


		
	if aiming:
		# player.look_at(player.transform.origin + arm.transform.basis.z, Vector3.UP)
		offset.x = aiming_offset
		offset.y = -.25
		offset.z = 5
		arm.spring_length = lerp(arm.spring_length, zoom_maximum, lerp_weight * delta)
		camera_y_rot_clamp = lerp(camera_y_rot_clamp, 80.0, lerp_weight * delta)

		
	else:
		offset.x = x_offset
		offset.y = y_offset
		offset.z = z_offset
		arm.spring_length = lerp(arm.spring_length, zoom_default, lerp_weight * delta)
		camera_y_rot_clamp = lerp(camera_y_rot_clamp, 0.0, lerp_weight * delta)

	

	camera.position = camera.position.lerp(offset, lerp_weight * delta)
	mouse_delta = Vector2.ZERO # Reset mouse delta to stop camera from rotating when not moving mouse

	#print(camera.position)
	#print(arm.spring_length)



func _input(event):
	if event.is_action_pressed("aim"):
		# camera_root_offset.rotate_y(PI/13)
		# camera_leaf_offset.rotate_y(-PI/13)
		aiming = true
		emit_signal("Aiming", aiming)
	if event.is_action_released("aim"):
		# camera_root_offset.rotate_y(-PI/13)
		# camera_leaf_offset.rotate_y(PI/13)
		aiming = false
		emit_signal("Aiming", aiming)
	if event is InputEventMouseMotion:
		mouse_delta = Vector2(event.relative.x, event.relative.y) * mouse_sensitivity # mouse vector since last frame

	





