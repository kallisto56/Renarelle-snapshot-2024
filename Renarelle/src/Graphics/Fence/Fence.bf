namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;
using System.Threading;


struct Fence
{
	public SDL_GPUFence* mHandle { get; protected set mut; }


	public this (SDL_GPUFence* handle)
	{
		this.mHandle = handle;
	}


	public bool IsSignaled ()
	{
		if (this.mHandle == null)
			return true;

		return SDL_QueryGPUFence(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
	}


	public void Release ()
	{
		SDL_ReleaseGPUFence(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
	}


	public Response WaitFor () mut
	{
		var handle = this.mHandle;
		var response = SDL_WaitForGPUFences(Renarelle.sGraphicsDevice.mHandle, true, &handle, 1);
		if (response == false)
			return new Error()..AppendCStr(SDL_GetError());

		SDL_ReleaseGPUFence(Renarelle.sGraphicsDevice.mHandle, this.mHandle);

		return .Ok;
	}


	static public Response WaitFor (bool bWaitAll = true, params Fence[] fences)
	{
		var array = scope SDL_GPUFence*[fences.Count];
		for (var n = 0; n < fences.Count; n++)
			array[n] = fences[n].mHandle;

		if (SDL_WaitForGPUFences(Renarelle.sGraphicsDevice.mHandle, bWaitAll, array.CArray(), uint32(array.Count)) == false)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	static public Response WaitFor (bool bWaitAll, List<Fence> fences)
	{
		var array = scope SDL_GPUFence*[fences.Count];
		for (var n = 0; n < fences.Count; n++)
			array[n] = fences[n].mHandle;

		if (SDL_WaitForGPUFences(Renarelle.sGraphicsDevice.mHandle, bWaitAll, array.CArray(), uint32(array.Count)) == false)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}
}