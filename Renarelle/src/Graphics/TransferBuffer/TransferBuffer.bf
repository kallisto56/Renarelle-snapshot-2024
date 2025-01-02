namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using System.Interop;
using SDL3.Raw;


class TransferBuffer : RefCounted
{
	public SDL_GPUTransferBuffer* mHandle { get; protected set; }
	public SDL_GPUTransferBufferUsage mUsage { get; protected set; }
	public int mSizeInBytes { get; protected set; }
	public void* mPtr { get; protected set; }

	public bool bIsInitialized { get; protected set; }
	public bool bIsMapped { get; protected set; }


	public Response Initialize (int mSizeInBytes, Self.Usage usage)
	{
		this.mSizeInBytes = uint32(mSizeInBytes);
		this.mUsage = (usage == .Download)
			? .SDL_GPU_TRANSFERBUFFERUSAGE_DOWNLOAD
			: .SDL_GPU_TRANSFERBUFFERUSAGE_UPLOAD;

		SDL_GPUTransferBufferCreateInfo createInfo = SDL_GPUTransferBufferCreateInfo()
		{
			usage = this.mUsage,
			size = uint32(this.mSizeInBytes),
			props = 0,
		};

		this.mHandle = SDL_CreateGPUTransferBuffer(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.bIsInitialized = true;

		return .Ok;
	}


	public Response Map (bool bCycle = false)
	{
		this.mPtr = SDL_MapGPUTransferBuffer(Renarelle.sGraphicsDevice.mHandle, this.mHandle, bCycle);
		if (this.mPtr == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.bIsMapped = true;
		return .Ok;
	}


	public void Unmap ()
	{
		SDL_UnmapGPUTransferBuffer(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
		this.bIsMapped = false;
	}


	public ~this ()
	{
		if (this.mHandle != null)
		{
			SDL_ReleaseGPUTransferBuffer(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
			this.mHandle = null;
		}
	}


	static public Response MemCpy (void* pOrigin, Buffer pDestination, int sizeInBytes, TransferBuffer transferBuffer = null)
	{
		return default;
	}
}