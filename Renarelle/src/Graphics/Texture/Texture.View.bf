namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


extension Texture
{
	public struct View
	{
		public SDL_GPUTexture* mHandle;
		public c_uint mWidth;
		public c_uint mHeight;


		public this (SDL_GPUTexture* handle, c_uint width, c_uint height)
		{
			this.mHandle = handle;
			this.mWidth = width;
			this.mHeight = height;
		}
	}
}
