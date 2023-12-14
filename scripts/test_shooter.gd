extends Node3D

@export_group("Properties")
@export var fire_from: RayCast3D

var range = 250
var speed = 25
# Called when the node enters the scene tree for the first time.
var projectile

func _ready():
	GlobalSignals.add_listener("Shoot", self, "_on_shoot")
	projectile = preload("res://objects/projectile.tscn")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	SurfaceTool.new()
	pass

func _on_shoot():
	print("player shot")
	var collision_point = get_collision_pt_and_obj()
	var direction = (collision_point[1] - fire_from.global_position).normalized()
	spawn_projectile(direction)


func get_collision_pt_and_obj():
	var Spray = Vector2(0,0)
	var _Camera = get_viewport().get_camera_3d()
	var _Viewport = get_viewport().get_size()
	var Ray_Origin = _Camera.project_ray_origin(_Viewport/2)
	var Ray_End = (Ray_Origin + _Camera.project_ray_normal((_Viewport/2)+Vector2i(Spray))*range)

	var intersection_ray = PhysicsRayQueryParameters3D.create(Ray_Origin,Ray_End)
	#New_Intersection.set_exclude(collision_exclusion)
	var Intersection = get_world_3d().direct_space_state.intersect_ray(intersection_ray)
	
	if not Intersection.is_empty():
		var Collision = [Intersection.collider,Intersection.position]
		return Collision
	else:
		return [null,Ray_End]

func spawn_projectile(direction: Vector3):
	var projectile_instance = projectile.instantiate()
	projectile_instance.SetVelocity(direction*speed)
	projectile_instance.Move(true)
	projectile_instance.position = fire_from.global_position #global position

	World.add_child(projectile_instance)
	var world = get_tree().get_root()
	# get_world_3d().get_tree().add_child(projectile_instance)
