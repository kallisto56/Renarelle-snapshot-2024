namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Pipeline
{
	public struct TargetInfo : IDisposable
	{
		public SDL_GPUColorTargetDescription[] mColorTargets;
		public SDL_GPUTextureFormat? mDepthStencilFormat;


		public void Dispose ()
		{
			delete this.mColorTargets;
		}
	}
}
