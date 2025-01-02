namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Buffer
{
	public enum IndexFormat
	{
		case UInt16;
		case UInt32;


		static public implicit operator SDL_GPUIndexElementSize (IndexFormat format)
		{
			return (format == .UInt32)
				? .SDL_GPU_INDEXELEMENTSIZE_32BIT
				: .SDL_GPU_INDEXELEMENTSIZE_16BIT
				;
		}
	}
}
