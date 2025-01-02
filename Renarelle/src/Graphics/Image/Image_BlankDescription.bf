namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Image
{
	public struct BlankDescription
	{
		public int mWidth;
		public int mHeight;
		public SDL_PixelFormat mDesiredPixelFormat = .SDL_PIXELFORMAT_RGBA32;
	}
}
