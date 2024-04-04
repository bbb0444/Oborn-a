extends Node3D
class_name ProjectileShooter

@export_group("Components")
@export var player_controller: PlayerController
@export var fire_from: RayCast3D
@export var camera: Camera3D

var incident_line
var reflected_line

var fire_from_point = Vector3(0,0,0)
var prev_fire_from_point = Vector3(0,0,0)
var collision_point = Vector3(0,0,0)
var prev_collision_point = Vector3(0,0,0)

var collistion_pt_and_obj
var collision_obj

var projectiles = []


signal Looking_At(fire_from_point, collision_point, collision_obj)

var range = 250
var speed = 25

var _aiming

# Called when the node enters the scene tree for the first time.
var projectile

func _ready():
	player_controller.connect("Shoot", Callable(self, "_on_shoot"))
	player_controller.connect("Aiming", Callable(self, "_set_aiming"))
	# GlobalSignals.add_listener("Shoot", self, "_on_shoot")
	projectile = preload("res://objects/projectile.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if _aiming:
		fire_from_point = fire_from.global_position
		collistion_pt_and_obj = get_collision_pt_and_obj(camera)
		collision_point = collistion_pt_and_obj[1]
		collision_obj = collistion_pt_and_obj[0]
		if collision_obj == null:
			collision_obj = {}
	
		if fire_from_point != prev_fire_from_point:
			prev_fire_from_point = fire_from_point
			emit_signal("Looking_At", fire_from_point, collision_point, collision_obj)
		elif collision_point != prev_collision_point:
			prev_collision_point = collision_point
			emit_signal("Looking_At", fire_from_point, collision_point, collision_obj)
		# print("fire_from_point: ", fire_from_point, "collision_point: ", collision_point, "collision_obj: ", collision_obj, "collistion_pt_and_obj: ", collistion_pt_and_obj)
		
  
func _set_aiming(aiming: bool):
	_aiming = aiming

func _on_shoot():
	#var collision_point = get_collision_pt_and_obj(camera)
	var direction = (collistion_pt_and_obj[1] - fire_from.global_position).normalized()
	spawn_projectile(direction,camera)
	#print("collision point: ", collision_point[1], "direction: ", direction)


func get_collision_pt_and_obj(camera):
	var mid_viewport = get_viewport().get_visible_rect().size / 2
	var Spray = Vector2(0,0)
	var _Viewport = get_viewport().get_size()
	var Ray_Origin = camera.project_ray_origin(mid_viewport)
	#print(Ray_Origin)
	var Ray_End = (Ray_Origin + camera.project_ray_normal((mid_viewport)+Vector2(Spray))*range)

	var intersection_ray = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	#New_Intersection.set_exclude(collision_exclusion)
	var Intersection = get_world_3d().direct_space_state.intersect_ray(intersection_ray)
	
	#print("ray origin: ", Ray_Origin, "ray end: ", Ray_End, "ray normal", camera.project_ray_normal((_Viewport/2)))
	#print(Intersection)
	if not Intersection.is_empty():
		var Collision = [Intersection,Intersection.position]
		# print(Intersection.collider, Intersection.collider.get_class())
		return Collision
	else:
		return [null,Ray_End]

func spawn_projectile(direction: Vector3, camera: Camera3D):
	var projectile_instance = projectile.instantiate()
	projectile_instance.position = fire_from.global_position #global position
	projectile_instance.rotation = camera.global_rotation #global rotation
	projectile_instance.SetVelocity(direction*speed)
	projectile_instance.Move(true)

	projectiles.append(projectile_instance)
	World.add_child(projectile_instance)
	var world = get_tree().get_root()
	# get_world_3d().get_tree().add_child(projectile_instance)
