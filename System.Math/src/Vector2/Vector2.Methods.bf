namespace System.Math;


using System;


extension Vector2
{
	[Inline]
	static public Vector2 Lerp (Vector2 lhs, Vector2 rhs, float alpha)
	{
		return Vector2(
			lhs.mX * (1 - alpha) + rhs.mX * alpha,
			lhs.mY * (1 - alpha) + rhs.mY * alpha
		);
	}


	[Inline]
	static public Vector2 Clamp (Vector2 value, Vector2 min, Vector2 max)
	{
		return Vector2(
			Math.Clamp(value.mX, min.mX, max.mX),
			Math.Clamp(value.mY, min.mY, max.mY)
		);
	}


	[Inline]
	static public Vector2 Min (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			Math.Min(lhs.mX, rhs.mX),
			Math.Min(lhs.mY, rhs.mY)
		);
	}


	[Inline]
	static public Vector2 Max (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			Math.Max(lhs.mX, rhs.mX),
			Math.Max(lhs.mY, rhs.mY)
		);
	}


	[Inline]
	static public float Distance (Vector2 lhs, Vector2 rhs)
	{
		return (lhs - rhs).mMagnitude;
	}


	[Inline]
	static public float Dot (Vector2 lhs, Vector2 rhs)
	{
		return (lhs.mX * rhs.mX) + (lhs.mY * rhs.mY);
	}


	[Inline]
	static public Vector2 PerpendicularClockwise (Vector2 input)
	{
		return Vector2(input.mY, -input.mX);
	}


	[Inline]
	static public Vector2 PerpendicularCounterClockwise (Vector2 input)
	{
		return Vector2(-input.mY, input.mX);
	}


	[Inline]
	static public Vector2 Abs (Vector2 v)
	{
		return Vector2(
			Math.Abs(v.mX),
			Math.Abs(v.mY)
		);
	}
}