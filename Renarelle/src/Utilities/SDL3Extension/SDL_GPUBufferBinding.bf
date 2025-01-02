namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;

using Renarelle;


extension SDL_GPUBufferBinding
{
	public this (Buffer buffer, int offset)
	{
		this.buffer = buffer.mHandle;
		this.offset = uint32(offset);
	}
}