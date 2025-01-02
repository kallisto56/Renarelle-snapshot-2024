namespace System.Math;


using System;


[CRepr]
struct Vector2
{
	const public Vector2 Zero = Vector2(0, 0);
	const public Vector2 One = Vector2(1, 1);


	public float[2] mValues;


	public this (float x, float y)
	{
		this.mValues = float[2] (x, y);
	}


	public this (float v)
	{
		this.mValues = float[2] (v, v);
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


	public float mWidth
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public float mHeight
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public float mMagnitude
	{
		[Inline] get { return Math.Sqrt(this.mX * this.mX + this.mY * this.mY); }
	}


	public float mSqrMagnitude
	{
		[Inline] get { return (this.mX * this.mX + this.mY * this.mY); }
	}


	public Vector2 mNormalized
	{
		[Inline] get { return this / this.mMagnitude; }
	}


	[Inline]
	public bool IsNaN ()
	{
		return this.mX.IsNaN || this.mY.IsNaN;
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Vector2({}, {})", this.mValues[0], this.mValues[1]);
	}
}