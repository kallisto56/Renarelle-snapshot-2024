namespace System.Math;


using System;


[CRepr]
struct Color
{
	public float[4] mValues;


	public this (float r, float g, float b, float a)
	{
		this.mValues = float[4] (r,g,b,a);
	}


	public float mR
	{
		get { return this.mValues[0]; }
		set mut { this.mValues[0] = value; }
	}


	public float mG
	{
		get { return this.mValues[1]; }
		set mut { this.mValues[1] = value; }
	}


	public float mB
	{
		get { return this.mValues[2]; }
		set mut { this.mValues[2] = value; }
	}


	public float mA
	{
		get { return this.mValues[3]; }
		set mut { this.mValues[3] = value; }
	}

	public uint32 ToUInt32 ()
	{
		return uint32(
			uint32(this.mValues[0] * 255) << 24 |
			uint32(this.mValues[1] * 255) << 16 |
			uint32(this.mValues[2] * 255) << 8 |
			uint32(this.mValues[3] * 255)
		);
	}


	public void ToUint32 (out uint8 r, out uint8 g, out uint8 b, out uint8 a)
	{
		r = uint8(this.mValues[0] * 255);
		g = uint8(this.mValues[1] * 255);
		b = uint8(this.mValues[2] * 255);
		a = uint8(this.mValues[3] * 255);
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("Color({}, {}, {}, {})", this.mR, this.mG, this.mB, this.mA);
	}
}