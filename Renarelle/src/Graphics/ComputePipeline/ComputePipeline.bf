namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class ComputePipeline
{
	public SDL_GPUComputePipeline* mHandle { get; protected set; }
}