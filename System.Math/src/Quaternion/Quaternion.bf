namespace System.Math;


using System;


[CRepr]
struct Quaternion
{
	const public Quaternion Identity = Quaternion(0, 0, 0, 1);


	public float[4] mValues;


	public this (float x, float y, float z, float w)
	{
		this.mValues = float[4] (x, y, z, w);
	}


	public this (Matrix4x4 m)
	{
		this.mValues = float[4]();

		this.mW = Math.Sqrt(Math.Max(0, 1 + m.m00 + m.m11 + m.m22)) / 2;

		this.mX = Math.Sqrt(Math.Max(0, 1 + m.m00 - m.m11 - m.m22)) / 2;
		this.mY = Math.Sqrt(Math.Max(0, 1 - m.m00 + m.m11 - m.m22)) / 2;
		this.mZ = Math.Sqrt(Math.Max(0, 1 - m.m00 - m.m11 + m.m22)) / 2;

		this.mX *= Math.Sign(this.mX * (m.m21 - m.m12));
		this.mY *= Math.Sign(this.mY * (m.m02 - m.m20));
		this.mZ *= Math.Sign(this.mZ * (m.m10 - m.m01));
	}


	public float mX
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public float mY
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public float mZ
	{
		[Inline] get { return this.mValues[2]; }
		[Inline] set mut { this.mValues[2] = value; }
	}


	public float mW
	{
		[Inline] get { return this.mValues[3]; }
		[Inline] set mut { this.mValues[3] = value; }
	}


	public float mMagnitude
	{
		[Inline] get { return Math.Sqrt((this.mX * this.mX + this.mY * this.mY) + (this.mZ * this.mZ + this.mW * this.mW)); }
	}


	public float mSqrMagnitude
	{
		[Inline] get { return (this.mX * this.mX + this.mY * this.mY) + (this.mZ * this.mZ + this.mW * this.mW); }
	}


	public Quaternion mNormalized
	{
		[Inline] get { return this / this.mMagnitude; }
	}


	public float mAngle
	{
		[Inline] get { return Math.Acos(this.mW) * 2.0F; }
	}


	public float mYaw
	{
		[Inline] get { return Math.Asin(-2.0F * (this.mX * this.mZ - this.mW * mY)); }
	}


	public float mPitch
	{
		[Inline] get
		{
			return Math.Atan2(
				2.0F * (mY * this.mZ + this.mW * this.mX),
				(this.mW * this.mW - this.mX * this.mX - mY * mY + this.mZ * this.mZ)
			);
		}
	}


	public float mRoll
	{
		[Inline] get
		{
			return Math.Atan2(
				2.0F * (this.mX * mY + this.mW * this.mZ),
				(this.mW * this.mW + this.mX * this.mX - mY * mY - this.mZ * this.mZ)
			);
		}
	}


	public Vector3 mEulerAngles
	{
		[Inline] get { return Vector3(this.mPitch, this.mYaw, this.mRoll); }
	}


	public Quaternion mConjugate
	{
		[Inline] get { return Quaternion(-this.mX, -mY, -this.mZ, this.mW); }
	}


	public Quaternion mInverse
	{
		[Inline] get { return this.mConjugate / this.mSqrMagnitude; }
	}


	public Quaternion Rotated (float angle, Vector3 v)
	{
		return this * Quaternion.FromAxisAngle(angle, v);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Quaternion({}, {}, {}, {})", this.mValues[0], this.mValues[1], this.mValues[2], this.mValues[3]);
	}
}