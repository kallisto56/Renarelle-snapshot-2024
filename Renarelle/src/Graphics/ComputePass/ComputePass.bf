namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


struct ComputePass
{
	public SDL_GPUComputePass* mHandle { get; }


	public this (SDL_GPUComputePass* handle)
	{
		this.mHandle = handle;
	}


}