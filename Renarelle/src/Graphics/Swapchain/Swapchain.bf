namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using System.Interop;
using SDL3.Raw;

using internal Renarelle.Window;


class Swapchain
{
	const public SDL_GPUPresentMode cDefaultPresentMode = .SDL_GPU_PRESENTMODE_VSYNC;
	const public SDL_GPUSwapchainComposition cDefaultComposition = .SDL_GPU_SWAPCHAINCOMPOSITION_SDR;

	public Window mWindow;
	public SDL_GPUTextureFormat mTextureFormat { get; protected set; }
	public SDL_GPUSwapchainComposition mComposition { get; protected set; }
	public SDL_GPUPresentMode mPresentMode { get; protected set; }


	public Response Initialize (Window window, SDL_GPUPresentMode presentMode, SDL_GPUSwapchainComposition composition)
	{
		this.mWindow = window;
		this.mPresentMode = presentMode;
		this.mComposition = composition;

		if (SDL_WindowSupportsGPUSwapchainComposition(Renarelle.sGraphicsDevice.mHandle, this.mWindow.mHandle, this.mComposition) == false)
			return new Error()..AppendF("Requested composition ({}) of swapchain is not supported.", this.mComposition);

		if (SDL_SetGPUSwapchainParameters(Renarelle.sGraphicsDevice.mHandle, this.mWindow.mHandle, this.mComposition, this.mPresentMode) == false)
			return new Error()..AppendCStr(SDL_GetError());

		this.mTextureFormat = SDL_GetGPUSwapchainTextureFormat(Renarelle.sGraphicsDevice.mHandle, this.mWindow.mHandle);
		if (this.mTextureFormat == .SDL_GPU_TEXTUREFORMAT_INVALID)
		{
			return new Error()..AppendF(
				"Received SDL_GPU_TEXTUREFORMAT_INVALID from SDL_GetGPUSwapchainTextureFormat; SDL_GetError: \"{}\"",
				StringView(SDL_GetError())
			);
		}

		return .Ok;
	}


	public Response<Texture.View> AcquireTexture (CommandBuffer commandBuffer)
	{
		c_uint width = ?;
		c_uint height = ?;
		SDL_GPUTexture* textureHandle = ?;

		if (SDL_AcquireGPUSwapchainTexture(commandBuffer.mHandle, this.mWindow.mHandle, &textureHandle, &width, &height) == false)
			return new Error()..AppendCStr(SDL_GetError());

		return Texture.View(textureHandle, width, height);
	}
}