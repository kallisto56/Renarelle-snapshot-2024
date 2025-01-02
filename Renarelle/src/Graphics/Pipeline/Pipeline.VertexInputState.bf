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
	public struct VertexInputState : IDisposable
	{
		public SDL_GPUVertexBufferDescription[] mBuffers;
		public SDL_GPUVertexAttribute[] mAttributes;


		public void Dispose ()
		{
			delete this.mBuffers;
			delete this.mAttributes;
		}
	}
}
