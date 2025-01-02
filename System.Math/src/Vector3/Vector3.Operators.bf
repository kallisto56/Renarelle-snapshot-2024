namespace System.Math;


using System;
using System.Collections;
using System.Diagnostics;


extension Vector3
{
	static public Vector3 operator + (Vector3 lhs, Vector3 rhs)
	{
		return Vector3(
			lhs.mX + rhs.mX,
			lhs.mY + rhs.mY,
			lhs.mZ + rhs.mZ
		);
	}


	static public Vector3 operator + (Vector3 lhs, float rhs)
	{
	    return Vector3(
	        lhs.mX + rhs,
	        lhs.mY + rhs,
	        lhs.mZ + rhs
	    );
	}


	static public Vector3 operator + (float lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs + rhs.mX,
	        lhs + rhs.mY,
	        lhs + rhs.mZ
	    );
	}


	static public Vector3 operator - (Vector3 lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs.mX - rhs.mX,
	        lhs.mY - rhs.mY,
	        lhs.mZ - rhs.mZ
	    );
	}


	static public Vector3 operator - (Vector3 lhs, float rhs)
	{
	    return Vector3(
	        lhs.mX - rhs,
	        lhs.mY - rhs,
	        lhs.mZ - rhs
	    );
	}


	static public Vector3 operator - (float lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs - rhs.mX,
	        lhs - rhs.mY,
	        lhs - rhs.mZ
	    );
	}


	static public Vector3 operator * (Vector3 lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs.mX * rhs.mX,
	        lhs.mY * rhs.mY,
	        lhs.mZ * rhs.mZ
	    );
	}


	static public Vector3 operator * (Vector3 lhs, float rhs)
	{
	    return Vector3(
	        lhs.mX * rhs,
	        lhs.mY * rhs,
	        lhs.mZ * rhs
	    );
	}


	static public Vector3 operator * (float lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs * rhs.mX,
	        lhs * rhs.mY,
	        lhs * rhs.mZ
	    );
	}


	static public Vector3 operator / (Vector3 lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs.mX / rhs.mX,
	        lhs.mY / rhs.mY,
	        lhs.mZ / rhs.mZ
	    );
	}


	static public Vector3 operator / (Vector3 lhs, float rhs)
	{
	    return Vector3(
	        lhs.mX / rhs,
	        lhs.mY / rhs,
	        lhs.mZ / rhs
	    );
	}


	static public Vector3 operator / (float lhs, Vector3 rhs)
	{
	    return Vector3(
	        lhs / rhs.mX,
	        lhs / rhs.mY,
	        lhs / rhs.mZ
	    );
	}


	static public Vector3 operator - (Vector3 v)
	{
	    return Vector3(
	        -v.mX,
	        -v.mY,
	        -v.mZ
	    );
	}


	static public bool operator == (Vector3 lhs, Vector3 rhs)
	{
	    return (
			lhs.mX == rhs.mX &&
			lhs.mY == rhs.mY &&
			lhs.mZ == rhs.mZ
	    );
	}


	static public bool operator != (Vector3 lhs, Vector3 rhs)
	{
	    return (
			lhs.mX != rhs.mX ||
			lhs.mY != rhs.mY ||
			lhs.mZ != rhs.mZ
		);
	}
}