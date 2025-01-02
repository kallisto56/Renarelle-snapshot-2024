namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


struct CopyPass
{
	public SDL_GPUCopyPass* mHandle { get; }


	public this (SDL_GPUCopyPass* handle)
	{
		this.mHandle = handle;
	}


	public Response UploadToGPUTexture(SDL_GPUTextureTransferInfo* source, SDL_GPUTextureRegion* destination, c_bool cycle)
	{
		return new Error();//void SDL_UploadToGPUTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureTransferInfo* source, SDL_GPUTextureRegion* destination, c_bool cycle);
	}


	public Response UploadToGPUBuffer(SDL_GPUTransferBufferLocation* source, SDL_GPUBufferRegion* destination, c_bool cycle)
	{
		return new Error();//void SDL_UploadToGPUBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUTransferBufferLocation* source, SDL_GPUBufferRegion* destination, c_bool cycle);
	}


	public Response CopyGPUTextureToTexture(SDL_GPUTextureLocation* source, SDL_GPUTextureLocation* destination, uint32 w, uint32 h, uint32 d, c_bool cycle)
	{
		return new Error();//void SDL_CopyGPUTextureToTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureLocation* source, SDL_GPUTextureLocation* destination, uint32 w, uint32 h, uint32 d, c_bool cycle);
	}


	public Response CopyGPUBufferToBuffer(SDL_GPUBufferLocation* source, SDL_GPUBufferLocation* destination, uint32 size, c_bool cycle)
	{
		return new Error();//void SDL_CopyGPUBufferToBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUBufferLocation* source, SDL_GPUBufferLocation* destination, uint32 size, c_bool cycle);
	}


	public Response DownloadFromGPUTexture(SDL_GPUTextureRegion* source, SDL_GPUTextureTransferInfo* destination)
	{
		return new Error();//void SDL_DownloadFromGPUTexture(SDL_GPUCopyPass* copy_pass, SDL_GPUTextureRegion* source, SDL_GPUTextureTransferInfo* destination);
	}


	public Response DownloadFromGPUBuffer(SDL_GPUBufferRegion* source, SDL_GPUTransferBufferLocation* destination)
	{
		return new Error();//void SDL_DownloadFromGPUBuffer(SDL_GPUCopyPass* copy_pass, SDL_GPUBufferRegion* source, SDL_GPUTransferBufferLocation* destination);
	}
}