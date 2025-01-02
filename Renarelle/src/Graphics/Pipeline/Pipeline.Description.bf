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
	public struct Description : IDisposable
	{
		public Shader mVertexShader;
		public Shader mFragmentShader;

		public VertexInputState mVertexInputState;
		public SDL_GPUPrimitiveType mPrimitiveType;
		public SDL_GPURasterizerState mRasterizerState;
		public SDL_GPUMultisampleState mMultisampleState;
		public SDL_GPUDepthStencilState mDepthStencilState;
		public TargetInfo mTargetInfo;

		public void Dispose ()
		{
			this.mVertexShader?.ReleaseRef();
			this.mFragmentShader?.ReleaseRef();

			this.mVertexInputState.Dispose();
			this.mTargetInfo.Dispose();
		}
	}
}
