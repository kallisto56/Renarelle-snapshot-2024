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
	public struct VertexLayout : IDisposable
	{
		public Element[] mElements;


		public this (params Element[] elements)
		{
			this.mElements = new Element[elements.Count];
			elements.CopyTo(this.mElements);
		}

		public void Dispose ()
		{
			delete this.mElements;
		}


		public struct Element
		{
			public int mLocation;
			public int mSlot;
			public SDL_GPUVertexElementFormat mFormat;
			public int mOffsetInBytes;

			public this (int location, int slot, SDL_GPUVertexElementFormat format, int offsetInBytes)
			{
				this.mLocation = location;
				this.mSlot = slot;
				this.mFormat = format;
				this.mOffsetInBytes = offsetInBytes;
			}
		}
	}
}
