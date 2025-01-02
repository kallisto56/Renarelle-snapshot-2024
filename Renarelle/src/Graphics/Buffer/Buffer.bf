namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using System.Interop;
using SDL3.Raw;


class Buffer : RefCounted
{
	public SDL_GPUBuffer* mHandle { get; protected set; }
	public int mSizeInBytes { get; protected set; }
	public SDL_GPUBufferUsageFlags mUsage { get; protected set; }
	public bool bIsInitialized { get; protected set; }


	public Response Initialize (int sizeInBytes, SDL_GPUBufferUsageFlags usage)
	{
		this.mSizeInBytes = sizeInBytes;
		this.mUsage = usage;

		SDL_GPUBufferCreateInfo createInfo = SDL_GPUBufferCreateInfo()
		{
			usage = this.mUsage,
			size = c_uint(mSizeInBytes),
			props = 0,
		};

		this.mHandle = SDL_CreateGPUBuffer(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.bIsInitialized = true;
		return .Ok;
	}


	public ~this ()
	{
		if (this.mHandle != null)
		{
			SDL_ReleaseGPUBuffer(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
		}
	}

	public Response Update (void* pData, int sizeInBytes, TransferBuffer transferBuffer = null)
	{
		var transferBuffer;
		defer { transferBuffer.ReleaseRef(); }

		if (transferBuffer == null)
		{
			transferBuffer = new TransferBuffer();
			transferBuffer.Initialize(sizeInBytes, .Upload).Resolve!();
		}

		transferBuffer.Map().Resolve!();
		Internal.MemCpy(transferBuffer.mPtr, pData, sizeInBytes);
		transferBuffer.Unmap();

		var commandBuffer = Renarelle.sGraphicsDevice.AcquireCommandBuffer().Resolve!();
		var copyPass = SDL_BeginGPUCopyPass(commandBuffer.mHandle);
		if (copyPass == null)
			return new Error()..AppendCStr(SDL_GetError());

		SDL_GPUTransferBufferLocation source = SDL_GPUTransferBufferLocation()
		{
			transfer_buffer = transferBuffer.mHandle,
			offset = 0,
		};

		SDL_GPUBufferRegion destination = SDL_GPUBufferRegion()
		{
			buffer = this.mHandle,
			offset = 0,
			size = uint32(sizeInBytes),
		};

		SDL_UploadToGPUBuffer(copyPass, &source, &destination, false);
		SDL_EndGPUCopyPass(copyPass);

		Renarelle.sGraphicsDevice.Submit(commandBuffer).Resolve!()
			.WaitFor().Resolve!();

		return .Ok;
	}
}


class IndexBuffer : RefCounted
{
	Buffer mBuffer;

	public SDL_GPUBuffer* mHandle => this.mBuffer?.mHandle;
	public int mSizeInBytes => this.mBuffer.mSizeInBytes;
	public Format mFormat { get; protected set; }
	public int mCapacity { get; protected set; }
	public int mElementSize { get; protected set; }


	public this ()
	{
		this.mBuffer = new Buffer();
	}


	public ~this ()
	{
		this.mBuffer.ReleaseRef();
	}


	public Response Initialize (int capacity, Format format = .UInt32)
	{
		this.mFormat = format;
		this.mCapacity = capacity;
		this.mElementSize = (this.mFormat == .UInt32)
			? sizeof(uint32)
			: sizeof(uint16);

		var sizeInBytes = this.mCapacity * this.mElementSize;
		this.mBuffer.Initialize(sizeInBytes, .SDL_GPU_BUFFERUSAGE_INDEX).Resolve!();

		return .Ok;
	}


	public enum Format
	{
		UInt32,
		UInt16,
	}
}


class VertexBuffer
{
	Buffer mBuffer;

	public SDL_GPUBuffer* mHandle => this.mBuffer?.mHandle;
	public int mSizeInBytes => this.mBuffer.mSizeInBytes;
	public int mCapacity { get; protected set; }
	public int mElementSize { get; protected set; }


	public this ()
	{
		this.mBuffer = new Buffer();
	}


	public ~this ()
	{
		this.mBuffer.ReleaseRef();
	}


	public Response Initialize<T> (int capacity) where T : struct
	{
		this.mCapacity = capacity;
		this.mElementSize = sizeof(T);

		var sizeInBytes = this.mCapacity * this.mElementSize;
		this.mBuffer.Initialize(sizeInBytes, .SDL_GPU_BUFFERUSAGE_VERTEX).Resolve!();

		return .Ok;
	}


	public Response WriteData<T> (T[] pData, int count)
	{
		return .Ok;
	}
}