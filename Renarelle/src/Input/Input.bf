namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;


static class Input
{
	static internal Response Update ()
	{
		Input.UpdateMouse();
		return .Ok;
	}
}