namespace System.Math;


using System;


struct Rectangle
{
	public float[4] mValues;


	public this (float x, float y, float width, float height)
	{
		this.mValues = float[4] (x, y, width, height);
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
}