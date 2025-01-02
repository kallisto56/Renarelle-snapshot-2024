namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;


extension SDL_GPUVertexAttribute
{
	public this (int location, int bufferSlot, SDL_GPUVertexElementFormat format, int offset)
	{
		this.location = uint32(location);
		this.buffer_slot = uint32(bufferSlot);
		this.format = format;
		this.offset = uint32(offset);
	}
}