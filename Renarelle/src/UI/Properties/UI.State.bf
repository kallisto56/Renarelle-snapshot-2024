namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension UI
{
	public enum State : int
	{
		IsDisabled 	= 1 << 0,
		IsNormal 	= 1 << 1,
		IsHovered 	= 1 << 2,
		IsPressed 	= 1 << 3,
		IsFocused 	= 1 << 4,
	}
}
