namespace Renarelle;


using System;
using System.Collections;
using System.Math;


extension UI
{
	public enum LayoutPattern : uint8
	{
		/// Left to right, top to bottom
		LRTB,

		/// Left to right, bottom to top
		LRBT,

		/// Right to left, top to bottom
		RLTB,

		/// Right to left, bottom to top
		RLBT,
	}
}