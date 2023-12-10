using Godot;
using System;

public partial class crosshair : Control
{
	public Line2D bottomLine;
	public Line2D topLine;
	public Line2D leftLine;
	public Line2D rightLine;

	public float openGap = 10;
	public float gap;

	public float opacity;

	public bool closing = false;
	public bool opening = false;

	public bool open = false;
	public bool close = false;


	[Export]
	public float thickness = 2;
	public float closeGap = 5;
	public float size = 15;

	public float lerpSpeed = 10;

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		bottomLine = GetNode<Line2D>("Reticle/Bottom");
		topLine = GetNode<Line2D>("Reticle/Top");
		leftLine = GetNode<Line2D>("Reticle/Left");
		rightLine = GetNode<Line2D>("Reticle/Right");

		//_setGap(closeGap);

		bottomLine.DefaultColor = Colors.Blue;
		topLine.DefaultColor = Colors.Blue;
		leftLine.DefaultColor = Colors.Blue;
		rightLine.DefaultColor = Colors.Blue;

		bottomLine.Width = thickness;
		topLine.Width = thickness;
		leftLine.Width = thickness;
		rightLine.Width = thickness;
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

	public void ChangeGap(double delta, bool shouldOpen)
	{
		if (shouldOpen && !opening)
		{
			opening = true;
			gap = closeGap;
			opacity = 1;

		}
		else if (!shouldOpen && !closing)
		{
			closing = true;
			gap = openGap;
			opacity = 0;
		}


		gap = Mathf.Lerp(gap, shouldOpen ? openGap : closeGap, Convert.ToSingle(lerpSpeed * delta));
		opacity = Mathf.Lerp(opacity, shouldOpen ? 0 : 1, Convert.ToSingle(lerpSpeed * delta));


		this.Modulate = new Color(1, 1, 1, opacity);

		if (Math.Abs(gap - (shouldOpen ? openGap : closeGap)) < 0.1)
		{
			opening = false;
			closing = false;
			open = false;
			close = false;
		}
	}

	public void _setGap(float gap)
	{
		bottomLine.Points = new Vector2[] { new Vector2(0, gap), new Vector2(0, size) };
		topLine.Points = new Vector2[] { new Vector2(0, -gap), new Vector2(0, -size) };
		leftLine.Points = new Vector2[] { new Vector2(-gap, 0), new Vector2(-size, 0) };
		rightLine.Points = new Vector2[] { new Vector2(gap, 0), new Vector2(size, 0) };
	}
}
