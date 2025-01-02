namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


extension Image
{
	public struct Description
	{
		public StringView mFileName;
		public SDL_PixelFormat? mDesiredPixelFormat = null;
	}
}
