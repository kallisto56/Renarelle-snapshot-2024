namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension SDL_GPUTextureSamplerBinding
{
	public this (Renarelle.Texture texture)
	{
		this.texture = texture.mHandle;
		this.sampler = texture.mSampler?.mHandle;
	}
}