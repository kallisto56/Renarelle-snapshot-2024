namespace System.Math;


using System;


extension Quaternion
{
	static public float Dot (Quaternion lhs, Quaternion rhs)
	{
		return (lhs.mX * rhs.mX + lhs.mY * rhs.mY) + (lhs.mZ * rhs.mZ + lhs.mW * rhs.mW);
	}


	static public Quaternion FromAxisAngle (float angle, Vector3 v)
	{
	    let s = Math.Sin(angle * 0.5F);
	    let c = Math.Cos(angle * 0.5F);

	    return Quaternion(
			v.mX * s,
			v.mY * s,
			v.mZ * s,
			c
		);
	}


	static public Quaternion AngleAxis (float radians, Vector3 axis)
	{
		if (axis.mSqrMagnitude == 0.0f)
		    return .Identity;

		var radians, axis;

		radians *= 0.5F;
		axis = axis.mNormalized * Math.Sin(radians);

		return Quaternion(axis.mX, axis.mY, axis.mZ, Math.Cos(radians)).mNormalized;
	}


	static public Quaternion FromRotation (Vector3 src, Vector3 dst)
	{
		Vector3 axis = Vector3.Cross(src, dst);
		float angle = Vector3.Angle(src, dst);
		return Quaternion.AngleAxis(angle, axis.mNormalized);
	}


	static public Quaternion Cross (Quaternion q1, Quaternion q2)
	{
	    return Quaternion(
			q1.mW * q2.mX + q1.mX * q2.mW + q1.mY * q2.mZ - q1.mZ * q2.mY,
			q1.mW * q2.mY + q1.mY * q2.mW + q1.mZ * q2.mX - q1.mX * q2.mZ,
			q1.mW * q2.mZ + q1.mZ * q2.mW + q1.mX * q2.mY - q1.mY * q2.mX,
			q1.mW * q2.mW - q1.mX * q2.mX - q1.mY * q2.mY - q1.mZ * q2.mZ
		);
	}


	static public Quaternion Lerp (Quaternion lhs, Quaternion rhs, float alpha)
	{
	    return Quaternion(
			lhs.mX * (1-alpha) + rhs.mX * alpha,
			lhs.mY * (1-alpha) + rhs.mY * alpha,
			lhs.mZ * (1-alpha) + rhs.mZ * alpha,
			lhs.mW * (1-alpha) + rhs.mW * alpha
		);
	}
}