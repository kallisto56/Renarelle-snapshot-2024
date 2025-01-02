namespace System.Math;


using System;


extension Quaternion
{
	static public bool operator == (Quaternion lhs, Quaternion rhs)
	{
		return (
			lhs.mX == rhs.mX &&
			lhs.mY == rhs.mY &&
			lhs.mZ == rhs.mZ &&
			lhs.mW == rhs.mW
		);
	}


	static public bool operator != (Quaternion lhs, Quaternion rhs)
	{
		return (
			lhs.mX != rhs.mX ||
			lhs.mY != rhs.mY ||
			lhs.mZ != rhs.mZ ||
			lhs.mW != rhs.mW
		);
	}


	static public Quaternion operator * (Quaternion lhs, Quaternion rhs)
	{
		return Quaternion(
			lhs.mW * rhs.mX + lhs.mX * rhs.mW + lhs.mY * rhs.mZ - lhs.mZ * rhs.mY,
			lhs.mW * rhs.mY + lhs.mY * rhs.mW + lhs.mZ * rhs.mX - lhs.mX * rhs.mZ,
			lhs.mW * rhs.mZ + lhs.mZ * rhs.mW + lhs.mX * rhs.mY - lhs.mY * rhs.mX,
			lhs.mW * rhs.mW - lhs.mX * rhs.mX - lhs.mY * rhs.mY - lhs.mZ * rhs.mZ
		);
	}


	static public Vector3 operator * (Quaternion q, Vector3 v)
	{
		float qx = q.mX * 2F;
		float qy = q.mY * 2F;
		float qz = q.mZ * 2F;

		float xx = q.mX * qx;
		float yy = q.mY * qy;
		float zz = q.mZ * qz;

		float xy = q.mX * qy;
		float xz = q.mX * qz;
		float yz = q.mY * qz;

		float wx = q.mW * qx;
		float wy = q.mW * qy;
		float wz = q.mW * qz;

		return Vector3(
			(1F - (yy + zz)) * v.mX + (xy - wz) * v.mY + (xz + wy) * v.mZ,
			(xy + wz) * v.mX + (1F - (xx + zz)) * v.mY + (yz - wx) * v.mZ,
			(xz - wy) * v.mX + (yz + wx) * v.mY + (1F - (xx + yy)) * v.mZ
		);
	}


	static public Vector3 operator * (Vector3 v, Quaternion q)
	{
		return q.mInverse * v;
	}


	static public Quaternion operator - (Quaternion v)
	{
	    return Quaternion(-v.mX, -v.mY, -v.mZ, -v.mW);
	}


	static public Quaternion operator + (Quaternion lhs, Quaternion rhs)
	{
	    return Quaternion(lhs.mX + rhs.mX, lhs.mY + rhs.mY, lhs.mZ + rhs.mZ, lhs.mW + rhs.mW);
	}


	static public Quaternion operator + (Quaternion lhs, float rhs)
	{
	    return Quaternion(lhs.mX + rhs, lhs.mY + rhs, lhs.mZ + rhs, lhs.mW + rhs);
	}


	static public Quaternion operator + (float lhs, Quaternion rhs)
	{
	    return Quaternion(lhs + rhs.mX, lhs + rhs.mY, lhs + rhs.mZ, lhs + rhs.mW);
	}


	static public Quaternion operator - (Quaternion lhs, Quaternion rhs)
	{
	    return Quaternion(lhs.mX - rhs.mX, lhs.mY - rhs.mY, lhs.mZ - rhs.mZ, lhs.mW - rhs.mW);
	}


	static public Quaternion operator - (Quaternion lhs, float rhs)
	{
	    return Quaternion(lhs.mX - rhs, lhs.mY - rhs, lhs.mZ - rhs, lhs.mW - rhs);
	}


	static public Quaternion operator - (float lhs, Quaternion rhs)
	{
	    return Quaternion(lhs - rhs.mX, lhs - rhs.mY, lhs - rhs.mZ, lhs - rhs.mW);
	}


	static public Quaternion operator * (Quaternion lhs, float rhs)
	{
	    return Quaternion(lhs.mX * rhs, lhs.mY * rhs, lhs.mZ * rhs, lhs.mW * rhs);
	}


	static public Quaternion operator * (float lhs, Quaternion rhs)
	{
	    return Quaternion(lhs * rhs.mX, lhs * rhs.mY, lhs * rhs.mZ, lhs * rhs.mW);
	}


	static public Quaternion operator / (Quaternion lhs, float rhs)
	{
	    return Quaternion(lhs.mX / rhs, lhs.mY / rhs, lhs.mZ / rhs, lhs.mW / rhs);
	}
}