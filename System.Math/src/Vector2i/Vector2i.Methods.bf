namespace System.Math;


using System;


extension Vector2i
{
	[Inline]
	static public Vector2i Lerp (Vector2i lhs, Vector2i rhs, float alpha)
	{
		return Vector2i(
			lhs.mX * (1 - alpha) + rhs.mX * alpha,
			lhs.mY * (1 - alpha) + rhs.mY * alpha
		);
	}


	[Inline]
	static public Vector2i Clamp (Vector2i value, Vector2i min, Vector2i max)
	{
		return Vector2i(
			Math.Clamp(value.mX, min.mX, max.mX),
			Math.Clamp(value.mY, min.mY, max.mY)
		);
	}


	[Inline]
	static public Vector2i Min (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			Math.Min(lhs.mX, rhs.mX),
			Math.Min(lhs.mY, rhs.mY)
		);
	}


	[Inline]
	static public Vector2i Max (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			Math.Max(lhs.mX, rhs.mX),
			Math.Max(lhs.mY, rhs.mY)
		);
	}


	[Inline]
	static public float Distance (Vector2i lhs, Vector2i rhs)
	{
		return (lhs - rhs).mMagnitude;
	}


	[Inline]
	static public float Dot (Vector2i lhs, Vector2i rhs)
	{
		return (lhs.mX * rhs.mX) + (lhs.mY * rhs.mY);
	}


	[Inline]
	static public Vector2i PerpendicularClockwise (Vector2i input)
	{
		return Vector2i(input.mY, -input.mX);
	}


	[Inline]
	static public Vector2i PerpendicularCounterClockwise (Vector2i input)
	{
		return Vector2i(-input.mY, input.mX);
	}


	[Inline]
	static public Vector2i Abs (Vector2i v)
	{
		return Vector2i(
			Math.Abs(v.mX),
			Math.Abs(v.mY)
		);
	}
}