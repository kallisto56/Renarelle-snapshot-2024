namespace System.Math;


using System;
using System.Collections;
using System.Diagnostics;


extension Vector4
{
	[Inline]
	static public Vector4 Lerp (Vector4 lhs, Vector4 rhs, float alpha)
	{
		return Vector4(
			lhs.mX * (1-alpha) + rhs.mX * alpha,
			lhs.mY * (1-alpha) + rhs.mY * alpha,
			lhs.mZ * (1-alpha) + rhs.mZ * alpha,
			lhs.mW * (1-alpha) + rhs.mW * alpha
		);
	}


	[Inline]
	static public Vector4 Clamp (Vector4 input, Vector4 min, Vector4 max)
	{
		return Vector4(
			Math.Clamp(input.mX, min.mX, max.mX),
			Math.Clamp(input.mY, min.mY, max.mY),
			Math.Clamp(input.mZ, min.mZ, max.mZ),
			Math.Clamp(input.mW, min.mW, max.mW)
		);
	}
}