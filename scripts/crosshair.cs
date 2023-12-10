using Godot;
using System;

public partial class crosshair : Control
{
	public Node GlobalSignals;
	public Node3D PlayerController;
	public Line2D bottomLine;
	public Line2D topLine;
	public Line2D leftLine;
	public Line2D rightLine;


	public float gap;
	public float length;

	public float opacity;

	public bool closing = false;
	public bool opening = false;

	public bool open = true;
	public bool close = false;


	[Export]
	public float thickness = 2;
	public float openGap = 15;
	public float closeGap = 10;
	public float size = 25;

	public float lerpSpeed = 10;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GlobalSignals = GetNode<Node>("/root/GlobalSignals");
		PlayerController = GetNode<Node3D>("%PlayerController");

		bottomLine = GetNode<Line2D>("Reticle/Bottom");
		topLine = GetNode<Line2D>("Reticle/Top");
		leftLine = GetNode<Line2D>("Reticle/Left");
		rightLine = GetNode<Line2D>("Reticle/Right");

		_setGap(closeGap, size);

		bottomLine.DefaultColor = Colors.Blue;
		topLine.DefaultColor = Colors.Blue;
		leftLine.DefaultColor = Colors.Blue;
		rightLine.DefaultColor = Colors.Blue;

		bottomLine.Width = thickness;
		topLine.Width = thickness;
		leftLine.Width = thickness;
		rightLine.Width = thickness;

		//GlobalSignals.Call("add_listener", "Aiming", this, nameof(_Aiming));
		var aimingCallable = new Callable(this, nameof(_Aiming));
		PlayerController.Connect("Aiming", aimingCallable);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
		if (open)
		{
			ChangeGap(delta, true);
		}
		else if (close)
		{
			ChangeGap(delta, false);
		}
	}

	public void _Aiming(bool aiming)
	{
		GD.Print("Aiming", aiming);
		if (aiming)
		{
			close = true;
			open = false;
		}
		else
		{
			close = false;
			open = true;
		}
	}

	public void ChangeGap(double delta, bool shouldOpen)
	{
		if (shouldOpen && !opening)
		{
			opening = true;
			gap = closeGap;
			opacity = 1;
			length = size;

		}
		else if (!shouldOpen && !closing)
		{
			closing = true;
			gap = openGap;
			opacity = 0;
			length = size;
		}



		gap = Mathf.Lerp(gap, shouldOpen ? openGap : closeGap, Convert.ToSingle(lerpSpeed * delta));
		length = Mathf.Lerp(length, shouldOpen ? size - openGap : size + closeGap, Convert.ToSingle(lerpSpeed * delta));
		opacity = Mathf.Lerp(opacity, shouldOpen ? 0 : 1, Convert.ToSingle(lerpSpeed * delta));
		opacity = opacity < 0.1 ? 0 : opacity > 0.9 ? 1 : opacity; // clamp opacity

		this.Modulate = new Color(1, 1, 1, opacity);

		_setGap(gap, length);

		if (Math.Abs(gap - (shouldOpen ? openGap : closeGap)) < 0.1)
		{
			opening = false;
			closing = false;
			open = false;
			close = false;
		}

	}

	public void _setGap(float gap, float length)
	{
		bottomLine.Points = new Vector2[] { new Vector2(0, gap), new Vector2(0, length) };
		topLine.Points = new Vector2[] { new Vector2(0, -gap), new Vector2(0, -length) };
		leftLine.Points = new Vector2[] { new Vector2(-gap, 0), new Vector2(-length, 0) };
		rightLine.Points = new Vector2[] { new Vector2(gap, 0), new Vector2(length, 0) };
	}
}
