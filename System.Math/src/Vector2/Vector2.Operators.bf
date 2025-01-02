namespace System.Math;


using System;


extension Vector2
{
	static public Vector2 operator + (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			lhs.mX + rhs.mX,
			lhs.mY + rhs.mY
		);
	}


	static public Vector2 operator - (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			lhs.mX - rhs.mX,
			lhs.mY - rhs.mY
		);
	}


	static public Vector2 operator * (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			lhs.mX * rhs.mX,
			lhs.mY * rhs.mY
		);
	}


	static public Vector2 operator / (Vector2 lhs, Vector2 rhs)
	{
		return Vector2(
			lhs.mX / rhs.mX,
			lhs.mY / rhs.mY
		);
	}


	[Commutable]
	static public Vector2 operator * (Vector2 lhs, float rhs)
	{
		return Vector2(
			lhs.mX * rhs,
			lhs.mY * rhs
		);
	}


	[Commutable]
	static public Vector2 operator / (Vector2 lhs, float rhs)
	{
		return Vector2(
			lhs.mX / rhs,
			lhs.mY / rhs
		);
	}
}