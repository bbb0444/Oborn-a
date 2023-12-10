extends CharacterBody3D

signal coin_collected

@export_subgroup("Components")
@export var spring_arm: Node3D

@export_subgroup("Properties")
@export var movement_speed = 250
@export var jump_strength = 7

var movement_velocity: Vector3
var rotation_direction: float
var gravity = 0

var previously_floored = false

var jump_single = true
var jump_double = true

var coins = 0

var lerpSpeed = 10

@onready var particles_trail = $ParticlesTrail
@onready var sound_footsteps = $SoundFootsteps
@onready var model = $Character
@onready var animation = $Character/AnimationPlayer
@onready var player_controller = get_parent()

# Functions

func _physics_process(delta):
	
	# Handle functions
	
	handle_controls(delta)
	handle_gravity(delta)
	
	handle_effects()
	
	# Movement

	var applied_velocity: Vector3
	
	applied_velocity = velocity.lerp(movement_velocity, delta * lerpSpeed)
	applied_velocity.y = -gravity
	
	velocity = applied_velocity
	move_and_slide()
	
	# Rotation

	if player_controller.aiming: #for some reason this moving this to player_controller under if aiming check doesnt work the same
		# var direction = spring_arm.transform.basis.z # - cuz + is backwards?
		# rotation_direction = atan2(direction.x, direction.z)
		# rotation.y = lerp_angle(rotation.y, rotation_direction, delta * lerpSpeed)
 
		#look_at(direction, Vector3.UP) 

		set_rotation(Vector3(0, get_rotation().y, 0)) #ignore x and z axis rotations (only rotate around y axis)
		rotation.y = lerp_angle(rotation.y, spring_arm.rotation.y, delta * lerpSpeed * 2) #rotate charater to face camera direction

	elif Vector2(velocity.z, velocity.x).length() > 0.1: #character is moving (checking if velocity z and x are greater than 0 ( 0.1 leniency cuz of velocity lerp) doesnt work becuase of negaive velocity values)
		rotation_direction = Vector2(velocity.z, velocity.x).angle() #get angle of velocity direction
		rotation.y = lerp_angle(rotation.y, rotation_direction, delta * lerpSpeed) #rotate charater to face velocity direction
		

	# print(rotation_direction, applied_velocity, velocity)

	# Falling/respawning
	
	if position.y < -lerpSpeed:
		get_tree().reload_current_scene() 
	
	# Animation for scale (jumping and landing)
	
	model.scale = model.scale.lerp(Vector3(1, 1, 1), delta * lerpSpeed)
	
	# Animation when landing
	
	if is_on_floor() and gravity > 2 and !previously_floored:
		model.scale = Vector3(1.25, 0.75, 1.25)
		Audio.play("res://sounds/land.ogg")
	
	previously_floored = is_on_floor()

# Handle animation(s)

func handle_effects():
	
	particles_trail.emitting = false
	sound_footsteps.stream_paused = true
	
	if is_on_floor():
		if abs(velocity.x) > 1 or abs(velocity.z) > 1:
			animation.play("walk", 0.5)
			particles_trail.emitting = true
			sound_footsteps.stream_paused = false
		else:
			animation.play("idle", 0.5)
	else:
		animation.play("jump", 0.5)

# Handle movement input

func handle_controls(delta):
	
	# Movement
	
	var input := Vector3.ZERO
	
	input.x = Input.get_axis("move_right", "move_left")
	input.z = Input.get_axis("move_back", "move_forward")
	
	input = input.rotated(Vector3.UP, spring_arm.rotation.y).normalized() # adjust input direction to follow camera direction
	
	movement_velocity = input * movement_speed * delta
	
	# Jumping
	
	if Input.is_action_just_pressed("jump"):
		
		if jump_single or jump_double:
			pass
			#Audio.play("res://sounds/jump.ogg")
		
		if jump_double:
			
			gravity = -jump_strength
			
			jump_double = false
			model.scale = Vector3(0.5, 1.5, 0.5)
			
		if(jump_single): jump()

# Handle gravity

func handle_gravity(delta):
	
	gravity += 25 * delta
	
	if gravity > 0 and is_on_floor():
		
		jump_single = true
		gravity = 0

# Jumping

func jump():
	
	gravity = -jump_strength
	
	model.scale = Vector3(0.5, 1.5, 0.5)
	
	jump_single = false;
	jump_double = true;

# Collecting coins

func collect_coin():
	
	coins += 1
	
	coin_collected.emit(coins)
