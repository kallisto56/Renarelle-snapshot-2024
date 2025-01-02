namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension RenderPass
{
	public struct Description : IDisposable
	{
		public ColorAttachment[] mColorAttachments;
		public DepthAttachment? mDepthAttachment;


		public void Dispose ()
		{
			delete this.mColorAttachments;
		}
	}
}
