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
	public struct DepthAttachment
	{
		public Texture mTexture;
		public bool bCycleTexture;

		public float mDepthClearValue;
		public SDL_GPULoadOp mDepthLoadOp;
		public SDL_GPUStoreOp mDepthStoreOp;

		public SDL_GPULoadOp mStencilLoadOp;
		public SDL_GPUStoreOp mStencilStoreOp;
		public uint8 mStencilClearValue;


		static public implicit operator SDL_GPUDepthStencilTargetInfo (DepthAttachment depthAttachment)
		{
			return SDL_GPUDepthStencilTargetInfo()
			{
				texture = depthAttachment.mTexture?.mHandle,
				clear_depth = depthAttachment.mDepthClearValue,
				load_op = depthAttachment.mDepthLoadOp,
				store_op = depthAttachment.mDepthStoreOp,
				stencil_load_op = depthAttachment.mStencilLoadOp,
				stencil_store_op = depthAttachment.mStencilStoreOp,
				cycle = depthAttachment.bCycleTexture,
				clear_stencil = depthAttachment.mStencilClearValue,
			};
		}
	}
}
