namespace System.Math;


using System;


extension Vector4
{
	static public bool operator == (Vector4 lhs, Vector4 rhs)
	{
		return lhs.mX == rhs.mX
			&& lhs.mY == rhs.mY
			&& lhs.mZ == rhs.mZ
			&& lhs.mW == rhs.mW
			;
	}


	static public bool operator != (Vector4 lhs, Vector4 rhs)
	{
		return lhs.mX != rhs.mX
			|| lhs.mY != rhs.mY
			|| lhs.mZ != rhs.mZ
			|| lhs.mW != rhs.mW
			;
	}


	static public Vector4 operator + (Vector4 lhs, Vector4 rhs)
	{
		return Vector4(
			lhs.mX + rhs.mX,
			lhs.mY + rhs.mY,
			lhs.mZ + rhs.mZ,
			lhs.mW + rhs.mW
		);
	}


	[Commutable]
	static public Vector4 operator + (Vector4 lhs, float rhs)
	{
		return Vector4(
			lhs.mX + rhs,
			lhs.mY + rhs,
			lhs.mZ + rhs,
			lhs.mW + rhs
		);
	}


	static public Vector4 operator - (Vector4 lhs, Vector4 rhs)
	{
		return Vector4(
			lhs.mX - rhs.mX,
			lhs.mY - rhs.mY,
			lhs.mZ - rhs.mZ,
			lhs.mW - rhs.mW
		);
	}


	static public Vector4 operator - (Vector4 lhs, float rhs)
	{
		return Vector4(
			lhs.mX - rhs,
			lhs.mY - rhs,
			lhs.mZ - rhs,
			lhs.mW - rhs
		);
	}


	static public Vector4 operator - (float lhs, Vector4 rhs)
	{
		return Vector4(
			lhs - rhs.mX,
			lhs - rhs.mY,
			lhs - rhs.mZ,
			lhs - rhs.mW
		);
	}


	[Commutable]
	static public Vector4 operator * (Vector4 lhs, Vector4 rhs)
	{
		return Vector4(
			lhs.mX * rhs.mX,
			lhs.mY * rhs.mY,
			lhs.mZ * rhs.mZ,
			lhs.mW * rhs.mW
		);
	}


	[Commutable]
	static public Vector4 operator * (Vector4 lhs, float rhs)
	{
		return Vector4(
			lhs.mX * rhs,
			lhs.mY * rhs,
			lhs.mZ * rhs,
			lhs.mW * rhs
		);
	}


	[Commutable]
	static public Vector4 operator / (Vector4 lhs, Vector4 rhs)
	{
		return Vector4(
			lhs.mX / rhs.mX,
			lhs.mY / rhs.mY,
			lhs.mZ / rhs.mZ,
			lhs.mW / rhs.mW
		);
	}


	static public Vector4 operator / (Vector4 lhs, float rhs)
	{
		return Vector4(
			lhs.mX / rhs,
			lhs.mY / rhs,
			lhs.mZ / rhs,
			lhs.mW / rhs
		);
	}


	static public Vector4 operator - (Vector4 v)
	{
		return Vector4(
			-v.mX,
			-v.mY,
			-v.mZ,
			-v.mW
		);
	}


}