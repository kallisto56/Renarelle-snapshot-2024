namespace System.Math;


using System;
using System.Collections;
using System.Diagnostics;


extension Color
{
	static public Color Lerp (Color lhs, Color rhs, float alpha)
	{
		return Color(
			lhs.mR * (1 - alpha) + rhs.mR * alpha,
			lhs.mG * (1 - alpha) + rhs.mG * alpha,
			lhs.mB * (1 - alpha) + rhs.mB * alpha,
			lhs.mA * (1 - alpha) + rhs.mA * alpha
		);
	}

	static public Color Clamp (Color input, Color min, Color max)
	{
		return Color(
			Math.Clamp(input.mR, min.mR, max.mR),
			Math.Clamp(input.mG, min.mG, max.mG),
			Math.Clamp(input.mB, min.mB, max.mB),
			Math.Clamp(input.mA, min.mA, max.mA)
		);
	}

	static public Color Clamp01 (Color input)
	{
		return Color(
			Math.Clamp01(input.mR),
			Math.Clamp01(input.mG),
			Math.Clamp01(input.mB),
			Math.Clamp01(input.mA)
		);
	}


	[Inline]
	static public void ConvertToUint32 (Color color, out uint32 r, out uint32 g, out uint32 b, out uint32 a)
	{
		r = uint32(color.mR * 255);
		g = uint32(color.mG * 255);
		b = uint32(color.mB * 255);
		a = uint32(color.mA * 255);
	}


	static public uint32 ConvertToRGBA8888 (Color color)
	{
		ConvertToUint32(color, var r, var g, var b, var a);
		return (r << 24) | (g << 16) | (b << 8) | (a);
	}


	static public uint32 ConvertToARGB8888 (Color color)
	{
		ConvertToUint32(color, var r, var g, var b, var a);
		return (a << 24) | (r << 16) | (g << 8) | (b);
	}


	static public uint32 ConvertToBGRA8888 (Color color)
	{
		ConvertToUint32(color, var r, var g, var b, var a);
		return (b << 24) | (g << 16) | (r << 8) | (a);
	}
}