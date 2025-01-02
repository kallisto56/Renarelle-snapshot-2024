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
	public struct ColorAttachment
	{
		public Texture mTexture;
		public int mMipLevelIndex;
		public int mLayerIndex;
		public Color mClearColor;
		public SDL_GPULoadOp mLoadOp;
		public SDL_GPUStoreOp mStoreOp;
		public Texture mResolveTexture;
		public int mResolveTextureMipLevel;
		public int mResolveTextureLayerIndex;
		public bool bCycleTexture;
		public bool bCycleResolveTexture;


		static public implicit operator SDL_GPUColorTargetInfo (ColorAttachment colorAttachment)
		{
			return SDL_GPUColorTargetInfo()
			{
				texture = colorAttachment.mTexture?.mHandle,
				mip_level = uint32(colorAttachment.mMipLevelIndex),
				layer_or_depth_plane = uint32(colorAttachment.mLayerIndex),
				clear_color = colorAttachment.mClearColor,
				load_op = colorAttachment.mLoadOp,
				store_op = colorAttachment.mStoreOp,
				resolve_texture = colorAttachment.mResolveTexture?.mHandle,
				resolve_mip_level = uint32(colorAttachment.mResolveTextureMipLevel),
				resolve_layer = uint32(colorAttachment.mResolveTextureLayerIndex),
				cycle = colorAttachment.bCycleTexture,
				cycle_resolve_texture = colorAttachment.bCycleResolveTexture,
			};
		}
	}
}
