extends Node3D

var projectile_shooter: ProjectileShooter
var show_projectile_path_incident
var show_projectile_path_reflected
var incident_path_color
var reflected_path_color

var incident_line: MeshInstance3D
var reflected_line: MeshInstance3D

@export_group("Properties")
var incident_ray_length:= 200
var reflected_ray_length:= 10


# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_shooter = get_parent().projectile_shooter
	show_projectile_path_incident = get_parent().show_projectile_path_incident
	show_projectile_path_reflected = get_parent().show_projectile_path_reflected
	incident_path_color = get_parent().incident_path_color
	reflected_path_color = get_parent().reflected_path_color

	projectile_shooter.connect("Looking_At", Callable (self, "_looking_at"))
	projectile_shooter.player_controller.connect("Aiming", Callable (self, "_set_aiming"))
	# pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _set_aiming(aiming: bool):
	if incident_line:
		incident_line.queue_free()
		incident_line = null
	if reflected_line:
		reflected_line.queue_free()
		reflected_line = null

func _looking_at(fire_from_point: Vector3, collision_point:Vector3, collision_obj: Dictionary):
	print("fire_from_point: ", fire_from_point, "collision_point: ", collision_point, "collision_obj: ", collision_obj)
	#print(reflected_line)
	if show_projectile_path_incident:
		if incident_line:
			incident_line.queue_free()
			incident_line = null
		incident_line = await create_line(fire_from_point, collision_point, incident_path_color)
		if incident_line:
			add_child(incident_line)
	
	if show_projectile_path_reflected:
		if collision_obj == {}:
			if reflected_line:
				reflected_line.queue_free()
				reflected_line = null
			return
		if reflected_line:
			reflected_line.queue_free()
			reflected_line = null
		reflected_line = await create_line(collision_point, reflected_end_point(fire_from_point, collision_point, collision_obj), reflected_path_color)
		if reflected_line:
			add_child(reflected_line)


func reflected_end_point(fire_from_point: Vector3, collision_point: Vector3, collision_obj: Dictionary):
	var D = (collision_point - fire_from_point).normalized()
	# # Get the normal vector of the surface at the collision point.
	var N = collision_obj.normal.normalized()
	# # Calculate the reflected vector.
	# var R = D - 2 * D.dot(N) * N
	# var reflected_end_point_pos = R.normalized() * reflected_ray_length

	return N * reflected_ray_length + collision_point #not really a reflection, just a normal from wall
	#return reflected_end_point_pos

func create_line(pos1: Vector3, pos2: Vector3, color = Color.WHITE_SMOKE):
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF

	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	immediate_mesh.surface_add_vertex(pos1)
	immediate_mesh.surface_add_vertex(pos2)
	immediate_mesh.surface_end()
	
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = color
	
	#get_tree().get_root().add_child(mesh_instance)
	# if persist_ms:
	# 	await get_tree().create_timer(persist_ms).timeout
	# 	mesh_instance.queue_free()
	# 	return null
	# else:
	return mesh_instance
				
