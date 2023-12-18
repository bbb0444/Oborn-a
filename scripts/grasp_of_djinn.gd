extends Node3D

@export_group("Components")
@export var projectile_shooter: ProjectileShooter

@export_group("Properties")
@export var show_projectile_path_incident = true
@export var show_projectile_path_reflected = true
@export var incident_path_color = Color.BLUE
@export var reflected_path_color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
