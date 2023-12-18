using Godot;
using System;
using System.Numerics;
using Vector3 = Godot.Vector3;

public partial class projectile : Node3D
{
	public MeshInstance3D meshInstance;
	public RayCast3D rayCast;
	public GpuParticles3D collisionParticles;
	public Timer despawnTimer;
	public Timer collisionDespawnTimer;

	public bool movement = false;

	public Vector3 velocity = new Vector3(0, 0, 0);

	// [Export]
	// public float SPEED = 20;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		meshInstance = GetNode<MeshInstance3D>("MeshInstance3D");
		rayCast = GetNode<RayCast3D>("RayCast3D");
		collisionParticles = GetNode<GpuParticles3D>("GPUParticles3D");
		despawnTimer = GetNode<Timer>("DespawnTimer"); // for despawning after a certain amount of time
		collisionDespawnTimer = GetNode<Timer>("CollisionDespawnTimer"); // for despawning after a collision
		var despawnCallable = new Callable(this, nameof(_Despawn));
		despawnTimer.Connect("timeout", despawnCallable);
		collisionDespawnTimer.Connect("timeout", despawnCallable);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (movement)
		{
			// this.LookAtFromPosition(this.GlobalPosition, this.Position + velocity, Vector3.Down);
			// this.GlobalPosition += GlobalTransform.Basis * velocity * (float)delta;
			this.GlobalTranslate(velocity * (float)delta);

		}
		if (rayCast.IsColliding())
		{
			//var collisionPoint = rayCast.GetCollisionPoint();
			// GD.Print("Collided");
			// meshInstance.Hide();
			collisionDespawnTimer.Start();
			collisionParticles.Emitting = true;



		}
	}

	public void SetVelocity(Vector3 velocity)
	{
		this.velocity = velocity;
		// Basis rotation = Basis.LookingAt(velocity.Normalized(), Vector3.Up);
		// GD.Print(rotation);
		// Basis objectBasis = this.GlobalTransform.Basis;
		// this.GlobalTransform = new Transform3D(Basis.LookingAt(velocity.Normalized(), Vector3.Up), this.GlobalTransform.Origin);
	}


	public void Move(bool move)
	{
		movement = move;
	}
	public void _Despawn()
	{
		this.QueueFree();
	}

}
