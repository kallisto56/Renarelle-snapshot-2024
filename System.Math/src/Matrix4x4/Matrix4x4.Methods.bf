namespace System.Math;


using System;


extension Matrix4x4
{
	public static Matrix4x4 Rotate (float angle, Vector3 v)
	{
	    var c = (float)Math.Cos((double)angle);
	    var s = (float)Math.Sin((double)angle);

	    var axis = v.mNormalized;
	    var temp = (1 - c) * axis;

	    var m = Identity;
	    m.m00 = c + temp.mX * axis.mX;
	    m.m01 = 0 + temp.mX * axis.mY + s * axis.mZ;
	    m.m02 = 0 + temp.mX * axis.mZ - s * axis.mY;

	    m.m10 = 0 + temp.mY * axis.mX - s * axis.mZ;
	    m.m11 = c + temp.mY * axis.mY;
	    m.m12 = 0 + temp.mY * axis.mZ + s * axis.mX;

	    m.m20 = 0 + temp.mZ * axis.mX + s * axis.mY;
	    m.m21 = 0 + temp.mZ * axis.mY - s * axis.mX;
	    m.m22 = c + temp.mZ * axis.mZ;
	    return m;
	}


	[Inline]
	static public Matrix4x4 CreateTranslation (Vector3 v)
	{
		return Matrix4x4(
			+1F, +0F, +0F, +0F,
			+0F, +1F, +0F, +0F,
			+0F, +0F, +1F, +0F,
			v.mX, v.mY, v.mZ, +1F
		);
	}


	[Inline]
	static public Matrix4x4 CreateRotation (Quaternion quaternion)
	{
		return Matrix4x4(quaternion);
	}


	[Inline]
	static public Matrix4x4 CreateScale (Vector3 v)
	{
		return Matrix4x4(
			v.mX, 0, 0, 0,
			0, v.mY, 0, 0,
			0, 0, v.mZ, 0,
			0, 0, 0, 1
		);
	}
	

	[Inline]
	static public Matrix4x4 CreateScale (float x, float y, float z)
	{
		return Matrix4x4(
			x, 0, 0, 0,
			0, y, 0, 0,
			0, 0, z, 0,
			0, 0, 0, 1
		);
	}


	static public Matrix4x4 CreateLookAt (Vector3 origin, Vector3 destination, Vector3 upwards)
	{
		Vector3 w = (destination - origin).mNormalized;
		Vector3 u = Vector3.Cross(w, -upwards).mNormalized;
		Vector3 v = Vector3.Cross(w, u);

		float m00 = u.mX;
		float m10 = u.mY;
		float m20 = u.mZ;

		float m01 = v.mX;
		float m11 = v.mY;
		float m21 = v.mZ;

		float m02 = w.mX;
		float m12 = w.mY;
		float m22 = w.mZ;

		float m30 = -Vector3.Dot(u, origin);
		float m31 = -Vector3.Dot(v, origin);
		float m32 = -Vector3.Dot(w, origin);

		return Matrix4x4(
			m00, m01, m02, 0.0F,
			m10, m11, m12, 0.0F,
			m20, m21, m22, 0.0F,
			m30, m31, m32, 1.0F
		);
	}


	static public Matrix4x4 CreateTRS (Vector3 position, Quaternion quaternion, Vector3 scale)
	{
		Matrix4x4 T = [Inline]CreateTranslation(position);
		Matrix4x4 R = [Inline]CreateRotation(quaternion);
		Matrix4x4 S = [Inline]CreateScale(scale);

		return T * R * S;
	}


	static public Matrix4x4 CreateOrthographic (float width, float height, float near, float far)
	{
		// VULKAN
		/*{
			float m00 = 2.0F / width;
			float m11 = 2.0F / height;
			float m22 = 1.0F / (near - far);
			float m33 = near / (near - far);

			return Matrix4x4(
				m00, 0.0F, 0.0F, 0.0F,
				0.0F, m11, 0.0F, 0.0F,
				0.0F, 0.0F, m22, 0.0F,
				-1.0F, -1.0F, m33, 1.0F
			);
		}*/
		// DIRECTX
		{
			float m00 = 2.0F / width;
			float m11 = -2.0F / height;
			float m22 = 1.0F / (near - far);
			float m33 = near / (near - far);

			return Matrix4x4(
				m00, 0.0F, 0.0F, 0.0F,
				0.0F, m11, 0.0F, 0.0F,
				0.0F, 0.0F, m22, 0.0F,
				-1.0F, 1.0F, m33, 1.0F
			);
		}
	}


	static public Matrix4x4 CreateOrthographic (float left, float right, float top, float bottom, float near , float far)
	{
		float m00 = 2.0F / (right - left);
		float m11 = 2.0F / (bottom - top);
		float m22 = 1.0F / (far - near);
		float m23 = near;
		float m30 = -(right + left) / (right - left);
		float m31 = -(bottom + top) / (bottom - top);
		float m32 = -near / (far - near);

		return Matrix4x4(
			m00, 0, 0, 0,
			0, m11, 0, 0,
			0, 0, m22, m23,
			m30, m31, m32, 0
		);
	}


	static public Matrix4x4 CreatePerspective (float fovy, float aspect, float near, float far)
	{
		float tanHalfFovy = Math.Tan(fovy / 2.0F);
		float m00 = 1.0F / (aspect * tanHalfFovy);
		float m11 = 1.0F / (tanHalfFovy);
		float m22 = far / (far - near);
		float m23 = 1.0F;
		float m32 = -(far * near) / (far - near);

		return Matrix4x4(
			m00, 00F, 00F, 00F,
			00F, m11, 00F, 00F,
			00F, 00F, m22, m23,
			00F, 00F, m32, 00F
		);
	}
}