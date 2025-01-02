namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


extension Window
{
	public enum ResponseToClosure
	{
		Ok,
		Cancel,
	}
}
