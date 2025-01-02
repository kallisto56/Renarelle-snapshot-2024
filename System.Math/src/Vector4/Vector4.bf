namespace System.Math;


using System;


[CRepr]
struct Vector4
{
	const public Vector4 Zero = Vector4(0, 0, 0, 0);
	const public Vector4 One = Vector4(1, 1, 1, 1);


	public float[4] mValues;


	public this (float x, float y, float z, float w)
	{
		this.mValues = float[4] (x, y, z, w);
	}


	public this (float[4] v)
	{
		this.mValues = float[4] (v[0], v[1], v[2], v[3]);
	}


	public this (int[4] v)
	{
		this.mValues = float[4] (v[0], v[1], v[2], v[3]);
	}


	public this (Vector2 v, float z, float w)
	{
		this.mValues = float[4] (v.mX, v.mY, z, w);
	}


	public this (Vector3 v, float w)
	{
		this.mValues = float[4] (v.mX, v.mY, v.mZ, w);
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


	public float mWidth
	{
		[Inline] get { return this.mValues[2]; }
		[Inline] set mut { this.mValues[2] = value; }
	}


	public float mHeight
	{
		[Inline] get { return this.mValues[3]; }
		[Inline] set mut { this.mValues[3] = value; }
	}


	public float mLeft
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public float mTop
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public float mRight
	{
		[Inline] get { return this.mValues[2]; }
		[Inline] set mut { this.mValues[2] = value; }
	}


	public float mBottom
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


	public Vector4 mNormalized
	{
		get { return this / this.mMagnitude; }
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Vector4({}, {}, {}, {})", this.mValues[0], this.mValues[1], this.mValues[2], this.mValues[3]);
	}


	public void GetComponents (out float x, out float y, out float z, out float w)
	{
		x = this.mX;
		y = this.mY;
		z = this.mZ;
		w = this.mW;
	}


	public void GetComponentsInt (out int x, out int y, out int z, out int w)
	{
		x = int(this.mX);
		y = int(this.mY);
		z = int(this.mZ);
		w = int(this.mW);
	}
}