// //broken use test_shooter.gd
// using Godot;
// using System;

// public partial class TestShooter : Node3D
// {

//     [ExportGroup("Components")]
//     public RayCast3D FireFrom;
//     public Node3D PlayerController;

//     [ExportGroup("Properties")]
//     private const int Range = 250;
//     private const int Speed = 25;

//     private PackedScene Projectile;
//     public Node GlobalSignals;


//     public override void _Ready()
//     {
//         GlobalSignals = GetNode<Node>("/root/GlobalSignals");
//         Callable _on_shoot = new Callable(this, nameof(_on_shoot));
//         PlayerController.Connect("Shoot", _on_shoot);
//         Projectile = (PackedScene)GD.Load("res://objects/projectile.tscn");
//     }

//     public override void _Process(double delta)
//     {
//         // SurfaceTool.new() is not needed in C#
//     }

//     private void _on_shoot()
//     {
//         Camera3D camera = GetViewport().GetCamera3D();
//         Array collisionPoint = GetCollisionPtAndObj(camera);
//         Vector3 direction = (collisionPoint[1] - FireFrom.GlobalTransform.origin).Normalized();
//         SpawnProjectile(direction, camera);
//     }

//     private Array GetCollisionPtAndObj(Camera3D camera)
//     {
//         Vector2I spray = new Vector2I(0, 0);
//         var midViewport = GetViewport().GetVisibleRect().Size / 2 
//         Vector3 rayOrigin = camera.ProjectRayOrigin(viewport / 2);
//         Vector3 rayEnd = rayOrigin + camera.ProjectRayNormal((viewport / 2) + spray) * Range;

//         PhysicsRayQueryParameters3D intersectionRay = new PhysicsRayQueryParameters3D(rayOrigin, rayEnd);
//         var intersection = GetWorld3D().DirectSpaceState.IntersectRay(intersectionRay);

//         if (!intersection.IsEmpty())
//         {
//             var collision = new Array { intersection.Collider, intersection.Position };
//             return collision;
//         }
//         else
//         {
//             return new Array { null, rayEnd };
//         }
//     }

//     private void SpawnProjectile(Vector3 direction, Camera3D camera)
//     {


//         var projectileInstance = (Node3D)Projectile.Instance();
//         projectileInstance.Translation = FireFrom.GlobalTransform.origin; // global position
//         projectileInstance.Rotation = new Vector3(0, camera.GlobalTransform.basis.GetEuler().y, 0); // global rotation
//         projectileInstance.SetVelocity(direction * Speed);
//         projectileInstance.Move(true);

//         GetTree().Root.AddChild(projectileInstance);
//     }
// }
