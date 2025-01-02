namespace System.Math;


using System;


[CRepr]
struct Vector2i
{
	const public Vector2i Zero = Vector2i(0, 0);
	const public Vector2i One = Vector2i(1, 1);


	public int[2] mValues;


	public this (float x, float y)
	{
		this.mValues = int[2] (int(x), int(y));
	}


	public this (int x, int y)
	{
		this.mValues = int[2] (x, y);
	}


	public this (int v)
	{
		this.mValues = int[2] (v, v);
	}


	public int mX
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public int mY
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public int mLeft
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public int mTop
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public int mWidth
	{
		[Inline] get { return this.mValues[0]; }
		[Inline] set mut { this.mValues[0] = value; }
	}


	public int mHeight
	{
		[Inline] get { return this.mValues[1]; }
		[Inline] set mut { this.mValues[1] = value; }
	}


	public float mMagnitude
	{
		[Inline] get { return Math.Sqrt(this.mX * this.mX + this.mY * this.mY); }
	}


	public int mSqrMagnitude
	{
		[Inline] get { return (this.mX * this.mX + this.mY * this.mY); }
	}


	public Vector2i mNormalized
	{
		[Inline] get { return this / this.mMagnitude; }
	}


	[Inline]
	public bool IsNaN ()
	{
		return false;
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Vector2i({}, {})", this.mValues[0], this.mValues[1]);
	}
}