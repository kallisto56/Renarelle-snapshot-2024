namespace System.Math;


using System;


extension Vector2i
{
	static public Vector2i operator + (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			lhs.mX + rhs.mX,
			lhs.mY + rhs.mY
		);
	}


	static public Vector2i operator - (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			lhs.mX - rhs.mX,
			lhs.mY - rhs.mY
		);
	}


	static public Vector2i operator * (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			lhs.mX * rhs.mX,
			lhs.mY * rhs.mY
		);
	}


	static public Vector2i operator / (Vector2i lhs, Vector2i rhs)
	{
		return Vector2i(
			lhs.mX / rhs.mX,
			lhs.mY / rhs.mY
		);
	}


	[Commutable]
	static public Vector2i operator * (Vector2i lhs, float rhs)
	{
		return Vector2i(
			lhs.mX * rhs,
			lhs.mY * rhs
		);
	}


	[Commutable]
	static public Vector2i operator / (Vector2i lhs, float rhs)
	{
		return Vector2i(
			lhs.mX / rhs,
			lhs.mY / rhs
		);
	}
}