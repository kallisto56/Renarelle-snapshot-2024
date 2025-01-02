namespace System.Math;


using System;
using System.Collections;
using System.Diagnostics;


extension Vector3
{
	[Inline]
	static public Vector3 Lerp (Vector3 lhs, Vector3 rhs, float alpha)
	{
		return Vector3(
			lhs.mX * (1-alpha) + rhs.mX * alpha,
			lhs.mY * (1-alpha) + rhs.mY * alpha,
			lhs.mZ * (1-alpha) + rhs.mZ * alpha
		);
	}


	[Inline]
	static public Vector3 Clamp (Vector3 v, Vector3 min, Vector3 max)
	{
		return Vector3(
			Math.Min(Math.Max(v.mX, min.mX), max.mX),
			Math.Min(Math.Max(v.mY, min.mY), max.mY),
			Math.Min(Math.Max(v.mZ, min.mZ), max.mZ)
		);
	}


	[Inline]
	static public Vector3 ClampMagnitude (Vector3 v, float maximumLength)
	{
		float inputSqrMagnitude = v.mSqrMagnitude;
		if (inputSqrMagnitude > maximumLength * maximumLength)
			return (v / Math.Sqrt(inputSqrMagnitude)) * maximumLength;

		return v;
	}


	[Inline]
	static public Vector3 Cross (Vector3 l, Vector3 r)
	{
		return Vector3(
			l.mY * r.mZ - l.mZ * r.mY,
			l.mZ * r.mX - l.mX * r.mZ,
			l.mX * r.mY - l.mY * r.mX
		);
	}


	[Inline]
	static public float Distance (Vector3 lhs, Vector3 rhs)
	{
		return (lhs - rhs).mMagnitude;
	}


	[Inline]
    static public float DistanceSqr (Vector3 lhs, Vector3 rhs)
	{
		return (lhs - rhs).mSqrMagnitude;
	}


	[Inline]
	static public float Dot (Vector3 lhs, Vector3 rhs)
	{
		return (lhs.mX * rhs.mX) + (lhs.mY * rhs.mY) + (lhs.mZ * rhs.mZ);
	}


	[Inline]
	static public Vector3 Abs (Vector3 v)
	{
		return Vector3(
			Math.Abs(v.mX),
			Math.Abs(v.mY),
			Math.Abs(v.mZ)
		);
	}


	static public float Angle (Vector3 lhs, Vector3 rhs)
	{
		float denominator = Math.Sqrt(lhs.mSqrMagnitude * rhs.mSqrMagnitude);
		if (denominator < Math.[Friend]sMachineEpsilonFloat)
		    return 0.0F;

		float dotProduct = Math.Clamp(Vector3.Dot(lhs, rhs) / denominator, -1.0F, 1.0F);
		return Math.ToDegrees(Math.Acos(dotProduct));
	}
}