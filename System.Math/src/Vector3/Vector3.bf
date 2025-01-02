namespace System.Math;


using System;


[CRepr]
struct Vector3
{
	const public Vector3 Zero = Vector3(0, 0, 0);
	const public Vector3 One = Vector3(1, 1, 1);

	const public Vector3 Right = Vector3(+1, 0, 0);
	const public Vector3 Left = Vector3(-1, 0, 0);

	const public Vector3 Forward = Vector3(0, 0, +1);
	const public Vector3 Back = Vector3(0, 0, -1);

	const public Vector3 Up = Vector3(0, 0, +1);
	const public Vector3 Down = Vector3(0, 0, -1);


	public float[3] mValues;


	public this (float x, float y, float z)
	{
		this.mValues = float[3] (x, y, z);
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


	public float mMagnitude
	{
		[Inline]
		get
		{
			return Math.Sqrt(((this.mX * this.mX + this.mY * this.mY) + this.mZ * this.mZ));
		}
	}


	public float mSqrMagnitude
	{
		[Inline] get { return ((this.mX * this.mX + this.mY * this.mY) + this.mZ * this.mZ); }
	}


	public Vector3 mNormalized
	{
		[Inline]
		get
		{
			float magnitude = this.mMagnitude;
			if (magnitude == 0.0F)
				return Vector3.Zero;

			return Vector3(
				float(double(this.mX) / double(magnitude)),
				float(double(this.mY) / double(magnitude)),
				float(double(this.mZ) / double(magnitude))
			);
		}
	}


	[Inline]
	public bool IsNaN ()
	{
		return this.mX.IsNaN || this.mY.IsNaN || this.mZ.IsNaN;
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Vector3({}, {}, {})", this.mValues[0], this.mValues[1], this.mValues[2]);
	}
}