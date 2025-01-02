namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


class FormatHelpers
{
	static public SDL_PixelFormat Convert (SDL_GPUTextureFormat format)
	{
		if (format == .SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM)
			return .SDL_PIXELFORMAT_RGBA8888;

		Runtime.FatalError();
	}

	public static Response<SDL_GPUSampleCount> CountSamples (int count)
	{
		switch (count)
		{
		case 1: return SDL_GPUSampleCount.SDL_GPU_SAMPLECOUNT_1;
		case 2: return SDL_GPUSampleCount.SDL_GPU_SAMPLECOUNT_2;
		case 4: return SDL_GPUSampleCount.SDL_GPU_SAMPLECOUNT_4;
		case 8: return SDL_GPUSampleCount.SDL_GPU_SAMPLECOUNT_8;
		default: return new Error();
		}
	}
}