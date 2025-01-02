namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;

using internal Renarelle.Window;


class GraphicsDevice : RefCounted
{
	List<CommandBuffer> mCommandBuffersReadyForUse;
	List<CommandBuffer> mCommandBuffersInUse;


	public List<GraphicsDevice.Backend> mAvailableBackends;

	public SDL_GPUDevice* mHandle { get; protected set; }

	public SDL_GPUShaderFormat mShaderFormat { get; protected set; }
	SDL_GPUTextureFormat? mSwapchainTextureFormat;

	public GraphicsDevice.Backend mBackend { get; protected set; }
	public StringView mDriverName { get; protected set; }

	public bool bIsInitialized => this.mHandle != null;
	public bool bIsDebuggingEnabled { get; protected set; }


	public this ()
	{
		this.mAvailableBackends = new List<GraphicsDevice.Backend>();
		this.mCommandBuffersReadyForUse = new List<CommandBuffer>();
		this.mCommandBuffersInUse = new List<CommandBuffer>();
	}


	public ~this ()
	{
		if (this.bIsInitialized == true)
		{
			SDL_DestroyGPUDevice(this.mHandle);
		}

		delete this.mAvailableBackends;
		
		for (var n = this.mCommandBuffersInUse.Count - 1; n >= 0; n--)
			delete this.mCommandBuffersInUse[n];

		for (var n = this.mCommandBuffersReadyForUse.Count - 1; n >= 0; n--)
			delete this.mCommandBuffersReadyForUse[n];

		delete this.mCommandBuffersReadyForUse;
		delete this.mCommandBuffersInUse;
	}


	public Response Initialize (Self.Description description)
	{
		this.GetAvailableBackends();

		this.mBackend = description.mGraphicsBackend;
		this.mDriverName = this.mBackend.GetSDLName();
		this.mShaderFormat = description.mGraphicsBackend.GetShaderFormat();
		this.bIsDebuggingEnabled = description.bEnableDebugging;

		this.mHandle = SDL_CreateGPUDevice(this.mShaderFormat, this.bIsDebuggingEnabled, this.mDriverName.ToScopeCStr!());
		if (this.mHandle == null)
		{
			var available = this.mAvailableBackends;
			var list = scope String();

			for (var n = 0; n < available.Count; n++)
			{
				list.Append(available[n]);
				if (n + 1 < available.Count)
					list.Append(", ");
			}

			return new Error()..AppendF(
				"Target graphics backend is not available; Target: {}; Available graphics backends are: [{}];",
				this.mDriverName, list
			);
		}

		return .Ok;
	}


	public Response ClaimWindow (Window window)
	{
		Debug.Assert(window != null);

		if (SDL_ClaimWindowForGPUDevice(this.mHandle, window.mHandle) == false)
			return new Error()..AppendCStr(SDL_GetError());

		var textureFormat = SDL_GetGPUSwapchainTextureFormat(this.mHandle, window.mHandle);
		if (textureFormat == .SDL_GPU_TEXTUREFORMAT_INVALID)
			return new Error()..AppendF("Swapchain's texture format is {}.", textureFormat);

		if (this.mSwapchainTextureFormat.HasValue == false)
		{
			this.mSwapchainTextureFormat = textureFormat;
		}
		else if (this.mSwapchainTextureFormat.Value != textureFormat)
		{
			return new Error()..AppendF(
				"Texture format of the window is not compatible with the format in which graphics device is operating on. Graphics device: {}; Swapchain: {};",
				this.mSwapchainTextureFormat.Value,
				textureFormat
			);
		}

		return .Ok;
	}


	public void ReleaseWindow (Window window)
	{
		Debug.Assert(this.mHandle != null);
		Debug.Assert(window != null);

		SDL_ReleaseWindowFromGPUDevice(this.mHandle, window.mHandle);
	}


	public Response<SDL_GPUTextureFormat> GetSwapchainTextureFormat ()
	{
		if (this.mSwapchainTextureFormat.HasValue == false)
			return new Error()..Append(
				"Unable to provide texture format of the swapchain, because no swapchain has been created through this graphics device"
			);

		return this.mSwapchainTextureFormat.Value;
	}


	public Response WaitForIdle ()
	{
		Debug.Assert(this.mHandle != null);

		if (SDL_WaitForGPUIdle(this.mHandle) == false)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	public Response<CommandBuffer> AcquireCommandBuffer ()
	{
		var pCommandBuffer = SDL_AcquireGPUCommandBuffer(this.mHandle);
		if (pCommandBuffer == null)
			return new Error()..AppendCStr(SDL_GetError());

		return this.GetOrAllocateCommandBuffer(pCommandBuffer);
	}


	public Response<Fence> Submit (CommandBuffer commandBuffer)
	{
		var fence = SDL_SubmitGPUCommandBufferAndAcquireFence(commandBuffer.mHandle);
		if (fence == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.mCommandBuffersInUse.Remove(commandBuffer);
		this.mCommandBuffersReadyForUse.Add(commandBuffer);

		return Fence(fence);
	}


	/*public void ReturnCommandBuffer (CommandBuffer commandBuffer)
	{
		this.mCommandBuffersInUse.Remove(commandBuffer);
		this.mCommandBuffersReadyForUse.Add(commandBuffer);
	}*/


	public Response<SDL_GPUTextureFormat> GetDepthAttachmentFormat ()
	{
		return new Error();
	}


	CommandBuffer GetOrAllocateCommandBuffer (SDL_GPUCommandBuffer* handle)
	{
		if (this.mCommandBuffersInUse.Count > 25)
			Debug.Warning!(scope $"Count of command buffers in use is equals: {this.mCommandBuffersInUse.Count}.");

		CommandBuffer commandBuffer = (this.mCommandBuffersReadyForUse.Count > 0)
			? this.mCommandBuffersReadyForUse.PopBack()
			: new CommandBuffer();

		commandBuffer.Reset(handle);
		return this.mCommandBuffersInUse.Add(.. commandBuffer);
	}


	void GetAvailableBackends ()
	{
		var countRenderDrivers = SDL_GetNumRenderDrivers();
		for (int32 index = 0; index < countRenderDrivers; index++)
		{
			var name = StringView(SDL_GetRenderDriver(index));
			if (name == "gpu")
				continue;

			var backend = GraphicsDevice.Backend(name);
			this.mAvailableBackends.Add(backend);
		}
	}
}