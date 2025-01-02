namespace System.Math;


using System;


extension Matrix4x4
{
	static public bool operator == (Matrix4x4 lhs, Matrix4x4 rhs)
	{
		return (
			lhs.m00 == rhs.m00 && lhs.m01 == rhs.m01 && lhs.m02 == rhs.m02 && lhs.m03 == rhs.m03 &&
			lhs.m10 == rhs.m10 && lhs.m11 == rhs.m11 && lhs.m12 == rhs.m12 && lhs.m13 == rhs.m13 &&
			lhs.m20 == rhs.m20 && lhs.m21 == rhs.m21 && lhs.m22 == rhs.m22 && lhs.m23 == rhs.m23 &&
			lhs.m30 == rhs.m30 && lhs.m31 == rhs.m31 && lhs.m32 == rhs.m32 && lhs.m33 == rhs.m33
		);
	}


	static public bool operator != (Matrix4x4 lhs, Matrix4x4 rhs)
	{
		return (
			lhs.m00 != rhs.m00 || lhs.m01 != rhs.m01 || lhs.m02 != rhs.m02 || lhs.m03 != rhs.m03 ||
			lhs.m10 != rhs.m10 || lhs.m11 != rhs.m11 || lhs.m12 != rhs.m12 || lhs.m13 != rhs.m13 ||
			lhs.m20 != rhs.m20 || lhs.m21 != rhs.m21 || lhs.m22 != rhs.m22 || lhs.m23 != rhs.m23 ||
			lhs.m30 != rhs.m30 || lhs.m31 != rhs.m31 || lhs.m32 != rhs.m32 || lhs.m33 != rhs.m33
		);
	}


	static public Matrix4x4 operator / (Matrix4x4 lhs, float rhs)
	{
		return Matrix4x4(
			lhs.m00 / rhs, lhs.m01 / rhs, lhs.m02 / rhs, lhs.m03 / rhs,
			lhs.m10 / rhs, lhs.m11 / rhs, lhs.m12 / rhs, lhs.m13 / rhs,
			lhs.m20 / rhs, lhs.m21 / rhs, lhs.m22 / rhs, lhs.m23 / rhs,
			lhs.m30 / rhs, lhs.m31 / rhs, lhs.m32 / rhs, lhs.m33 / rhs
		);
	}


	static public Matrix4x4 operator * (Matrix4x4 lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
		    m00: ((lhs.m00 * rhs.m00 + lhs.m10 * rhs.m01) + (lhs.m20 * rhs.m02 + lhs.m30 * rhs.m03)),
		    m01: ((lhs.m01 * rhs.m00 + lhs.m11 * rhs.m01) + (lhs.m21 * rhs.m02 + lhs.m31 * rhs.m03)),
		    m02: ((lhs.m02 * rhs.m00 + lhs.m12 * rhs.m01) + (lhs.m22 * rhs.m02 + lhs.m32 * rhs.m03)),
		    m03: ((lhs.m03 * rhs.m00 + lhs.m13 * rhs.m01) + (lhs.m23 * rhs.m02 + lhs.m33 * rhs.m03)),

		    m10: ((lhs.m00 * rhs.m10 + lhs.m10 * rhs.m11) + (lhs.m20 * rhs.m12 + lhs.m30 * rhs.m13)),
		    m11: ((lhs.m01 * rhs.m10 + lhs.m11 * rhs.m11) + (lhs.m21 * rhs.m12 + lhs.m31 * rhs.m13)),
		    m12: ((lhs.m02 * rhs.m10 + lhs.m12 * rhs.m11) + (lhs.m22 * rhs.m12 + lhs.m32 * rhs.m13)),
		    m13: ((lhs.m03 * rhs.m10 + lhs.m13 * rhs.m11) + (lhs.m23 * rhs.m12 + lhs.m33 * rhs.m13)),

		    m20: ((lhs.m00 * rhs.m20 + lhs.m10 * rhs.m21) + (lhs.m20 * rhs.m22 + lhs.m30 * rhs.m23)),
		    m21: ((lhs.m01 * rhs.m20 + lhs.m11 * rhs.m21) + (lhs.m21 * rhs.m22 + lhs.m31 * rhs.m23)),
		    m22: ((lhs.m02 * rhs.m20 + lhs.m12 * rhs.m21) + (lhs.m22 * rhs.m22 + lhs.m32 * rhs.m23)),
		    m23: ((lhs.m03 * rhs.m20 + lhs.m13 * rhs.m21) + (lhs.m23 * rhs.m22 + lhs.m33 * rhs.m23)),

		    m30: ((lhs.m00 * rhs.m30 + lhs.m10 * rhs.m31) + (lhs.m20 * rhs.m32 + lhs.m30 * rhs.m33)),
		    m31: ((lhs.m01 * rhs.m30 + lhs.m11 * rhs.m31) + (lhs.m21 * rhs.m32 + lhs.m31 * rhs.m33)),
		    m32: ((lhs.m02 * rhs.m30 + lhs.m12 * rhs.m31) + (lhs.m22 * rhs.m32 + lhs.m32 * rhs.m33)),
		    m33: ((lhs.m03 * rhs.m30 + lhs.m13 * rhs.m31) + (lhs.m23 * rhs.m32 + lhs.m33 * rhs.m33))
		);
	}


	static public Vector2 operator * (Matrix4x4 m, Vector2 v)
	{
	    return Vector2(
			((m.m00 * v.mX + m.m10 * v.mY) + m.m30),
			((m.m01 * v.mX + m.m11 * v.mY) + m.m31)
		);
	}


	static public Vector3 operator * (Matrix4x4 m, Vector3 v)
	{
	    return Vector3(
			((m.m00 * v.mX + m.m10 * v.mY) + (m.m20 * v.mZ + m.m30)),
			((m.m01 * v.mX + m.m11 * v.mY) + (m.m21 * v.mZ + m.m31)),
			((m.m02 * v.mX + m.m12 * v.mY) + (m.m22 * v.mZ + m.m32))
		);
	}


	static public Vector4 operator * (Matrix4x4 m, Vector4 v)
	{
	    return Vector4(
			((m.m00 * v.mX) + (m.m10 * v.mY) + (m.m20 * v.mZ) + (m.m30 * v.mW)),
			((m.m01 * v.mX) + (m.m11 * v.mY) + (m.m21 * v.mZ) + (m.m31 * v.mW)),
			((m.m02 * v.mX) + (m.m12 * v.mY) + (m.m22 * v.mZ) + (m.m32 * v.mW)),
			((m.m03 * v.mX) + (m.m13 * v.mY) + (m.m23 * v.mZ) + (m.m33 * v.mW))
		);
	}


	static public Matrix4x4 operator / (Matrix4x4 lhs, Matrix4x4 rhs)
	{
	    return lhs * rhs.mInverse;
	}


	static public Matrix4x4 operator + (Matrix4x4 lhs, Matrix4x4 rhs)
	{
		return Matrix4x4(
		    m00: (lhs.m00 + rhs.m00),
		    m01: (lhs.m01 + rhs.m01),
		    m02: (lhs.m02 + rhs.m02),
		    m03: (lhs.m03 + rhs.m03),

		    m10: (lhs.m10 + rhs.m10),
		    m11: (lhs.m11 + rhs.m11),
		    m12: (lhs.m12 + rhs.m12),
		    m13: (lhs.m13 + rhs.m13),

		    m20: (lhs.m20 + rhs.m20),
		    m21: (lhs.m21 + rhs.m21),
		    m22: (lhs.m22 + rhs.m22),
		    m23: (lhs.m23 + rhs.m23),

		    m30: (lhs.m30 + rhs.m30),
		    m31: (lhs.m31 + rhs.m31),
		    m32: (lhs.m32 + rhs.m32),
		    m33: (lhs.m33 + rhs.m33)
		);
	}


	static public Matrix4x4 operator + (Matrix4x4 lhs, float rhs)
	{
		return Matrix4x4(
		    m00: (lhs.m00 + rhs),
		    m01: (lhs.m01 + rhs),
		    m02: (lhs.m02 + rhs),
		    m03: (lhs.m03 + rhs),

		    m10: (lhs.m10 + rhs),
		    m11: (lhs.m11 + rhs),
		    m12: (lhs.m12 + rhs),
		    m13: (lhs.m13 + rhs),

		    m20: (lhs.m20 + rhs),
		    m21: (lhs.m21 + rhs),
		    m22: (lhs.m22 + rhs),
		    m23: (lhs.m23 + rhs),

		    m30: (lhs.m30 + rhs),
		    m31: (lhs.m31 + rhs),
		    m32: (lhs.m32 + rhs),
		    m33: (lhs.m33 + rhs)
		);
	}


	static public Matrix4x4 operator + (float lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
	        m00: (lhs + rhs.m00),
	        m01: (lhs + rhs.m01),
	        m02: (lhs + rhs.m02),
	        m03: (lhs + rhs.m03),

	        m10: (lhs + rhs.m10),
	        m11: (lhs + rhs.m11),
	        m12: (lhs + rhs.m12),
	        m13: (lhs + rhs.m13),

	        m20: (lhs + rhs.m20),
	        m21: (lhs + rhs.m21),
	        m22: (lhs + rhs.m22),
	        m23: (lhs + rhs.m23),

	        m30: (lhs + rhs.m30),
	        m31: (lhs + rhs.m31),
	        m32: (lhs + rhs.m32),
	        m33: (lhs + rhs.m33)
	    );
	}


	static public Matrix4x4 operator - (Matrix4x4 lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
	        m00: (lhs.m00 - rhs.m00),
	        m01: (lhs.m01 - rhs.m01),
	        m02: (lhs.m02 - rhs.m02),
	        m03: (lhs.m03 - rhs.m03),

	        m10: (lhs.m10 - rhs.m10),
	        m11: (lhs.m11 - rhs.m11),
	        m12: (lhs.m12 - rhs.m12),
	        m13: (lhs.m13 - rhs.m13),

	        m20: (lhs.m20 - rhs.m20),
	        m21: (lhs.m21 - rhs.m21),
	        m22: (lhs.m22 - rhs.m22),
	        m23: (lhs.m23 - rhs.m23),

	        m30: (lhs.m30 - rhs.m30),
	        m31: (lhs.m31 - rhs.m31),
	        m32: (lhs.m32 - rhs.m32),
	        m33: (lhs.m33 - rhs.m33)
	    );
	}


	static public Matrix4x4 operator - (Matrix4x4 lhs, float rhs)
	{
	    return Matrix4x4(
	        m00: (lhs.m00 - rhs),
	        m01: (lhs.m01 - rhs),
	        m02: (lhs.m02 - rhs),
	        m03: (lhs.m03 - rhs),

	        m10: (lhs.m10 - rhs),
	        m11: (lhs.m11 - rhs),
	        m12: (lhs.m12 - rhs),
	        m13: (lhs.m13 - rhs),

	        m20: (lhs.m20 - rhs),
	        m21: (lhs.m21 - rhs),
	        m22: (lhs.m22 - rhs),
	        m23: (lhs.m23 - rhs),

	        m30: (lhs.m30 - rhs),
	        m31: (lhs.m31 - rhs),
	        m32: (lhs.m32 - rhs),
	        m33: (lhs.m33 - rhs)
	    );
	}


	static public Matrix4x4 operator - (float lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
	        m00: (lhs - rhs.m00),
	        m01: (lhs - rhs.m01),
	        m02: (lhs - rhs.m02),
	        m03: (lhs - rhs.m03),

	        m10: (lhs - rhs.m10),
	        m11: (lhs - rhs.m11),
	        m12: (lhs - rhs.m12),
	        m13: (lhs - rhs.m13),

	        m20: (lhs - rhs.m20),
	        m21: (lhs - rhs.m21),
	        m22: (lhs - rhs.m22),
	        m23: (lhs - rhs.m23),

	        m30: (lhs - rhs.m30),
	        m31: (lhs - rhs.m31),
	        m32: (lhs - rhs.m32),
	        m33: (lhs - rhs.m33)
	    );
	}


	static public Matrix4x4 operator / (float lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
	        m00: (lhs / rhs.m00),
	        m01: (lhs / rhs.m01),
	        m02: (lhs / rhs.m02),
	        m03: (lhs / rhs.m03),

	        m10: (lhs / rhs.m10),
	        m11: (lhs / rhs.m11),
	        m12: (lhs / rhs.m12),
	        m13: (lhs / rhs.m13),

	        m20: (lhs / rhs.m20),
	        m21: (lhs / rhs.m21),
	        m22: (lhs / rhs.m22),
	        m23: (lhs / rhs.m23),

	        m30: (lhs / rhs.m30),
	        m31: (lhs / rhs.m31),
	        m32: (lhs / rhs.m32),
	        m33: (lhs / rhs.m33)
	    );
	}


	static public Matrix4x4 operator * (Matrix4x4 lhs, float rhs)
	{
	    return Matrix4x4(
	        m00: (lhs.m00 * rhs),
	        m01: (lhs.m01 * rhs),
	        m02: (lhs.m02 * rhs),
	        m03: (lhs.m03 * rhs),

	        m10: (lhs.m10 * rhs),
	        m11: (lhs.m11 * rhs),
	        m12: (lhs.m12 * rhs),
	        m13: (lhs.m13 * rhs),

	        m20: (lhs.m20 * rhs),
	        m21: (lhs.m21 * rhs),
	        m22: (lhs.m22 * rhs),
	        m23: (lhs.m23 * rhs),

	        m30: (lhs.m30 * rhs),
	        m31: (lhs.m31 * rhs),
	        m32: (lhs.m32 * rhs),
	        m33: (lhs.m33 * rhs)
	    );
	}


	static public Matrix4x4 operator * (float lhs, Matrix4x4 rhs)
	{
	    return Matrix4x4(
	        m00: (lhs * rhs.m00),
	        m01: (lhs * rhs.m01),
	        m02: (lhs * rhs.m02),
	        m03: (lhs * rhs.m03),

	        m10: (lhs * rhs.m10),
	        m11: (lhs * rhs.m11),
	        m12: (lhs * rhs.m12),
	        m13: (lhs * rhs.m13),

	        m20: (lhs * rhs.m20),
	        m21: (lhs * rhs.m21),
	        m22: (lhs * rhs.m22),
	        m23: (lhs * rhs.m23),

	        m30: (lhs * rhs.m30),
	        m31: (lhs * rhs.m31),
	        m32: (lhs * rhs.m32),
	        m33: (lhs * rhs.m33)
	    );
	}
}