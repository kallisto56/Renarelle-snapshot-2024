namespace Renarelle;


using System;
using System.Collections;
using System.Math;


extension UI
{
	public enum LineBreak : uint16
	{
		Before = 0x0001,
		Intact = 0x0010,
		After = 0x0100
	}
}