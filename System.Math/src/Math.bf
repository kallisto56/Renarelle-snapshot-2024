namespace System;


using System;
using System.Collections;
using System.Diagnostics;

using System.Math;


extension Math
{
	[Inline]
	static public float ToRadians (float degrees)
	{
		return degrees * 0.01745329251994329576922222222222F;
	}

	[Inline]
	static public float ToDegrees (float radians)
	{
		return radians * 57.295779513082320876846364344191F;
	}

	static public float Clamp01 (float value)
	{
		if (value < 0)
		    return 0;
		else if (value > 1)
			return 1;
		return value;
	}
}