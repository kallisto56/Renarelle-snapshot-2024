namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


extension Texture
{
	public struct Description
	{
		public SDL_GPUTextureType mType = .SDL_GPU_TEXTURETYPE_2D;
		public SDL_GPUTextureFormat mFormat = .SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM;
		public SDL_GPUTextureUsageFlags mUsage = .SDL_GPU_TEXTUREUSAGE_GRAPHICS_STORAGE_READ;

		public int mWidth;
		public int mHeight;
		public int mDepth = 1;

		public int mCountLayers = 1;
		public int mCountMipLevels = 1;
		public int mCountSamplesPerTexel = 1;

		public Sampler mSampler;
	}
}
