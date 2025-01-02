namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Renderer2D
{
	public struct Description
	{
		const public int cMaximumCountIndices = 786432;
		const public int cMaximumCountVertices = 786432;

		public Window mWindow;
		public RenderPass mRenderPass;

		public int mMaxCountVertices = cMaximumCountVertices;
		public int mMaxCountIndices = cMaximumCountIndices;
	}
}