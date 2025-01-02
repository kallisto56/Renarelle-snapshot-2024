namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Threading;
using System.Math;
using SDL3.Raw;
using System.Interop;

using internal Renarelle.Window;


class CommandBuffer
{
	public SDL_GPUCommandBuffer* mHandle { get; protected set; }

	public RenderPass mRenderPass { get; protected set; }
	public Pipeline mGraphicsPipeline { get; protected set; }

	public ComputePass? mComputePass { get; protected set; }
	public ComputePipeline mComputePipeline { get; protected set; }

	public CopyPass? mCopyPass { get; protected set; }


	public void Reset (SDL_GPUCommandBuffer* handle)
	{
		this.mHandle = handle;

		this.mRenderPass = null;
		this.mGraphicsPipeline = null;

		this.mComputePass = null;
		this.mComputePipeline = null;

		this.mCopyPass = null;
	}


	public Response PushVertexUniformData (int slotIdx, void* pData, int sizeInBytes)
	{
		Debug.Assert(slotIdx >= 0);
		Debug.Assert(pData != null);
		Debug.Assert(sizeInBytes > 0);

		SDL_PushGPUVertexUniformData(this.mHandle, uint32(slotIdx), pData, uint32(sizeInBytes));
		return .Ok;
	}


	public Response PushFragmentUniformData (int slotIdx, void* pData, int sizeInBytes)
	{
		Debug.Assert(slotIdx >= 0);
		Debug.Assert(pData != null);
		Debug.Assert(sizeInBytes > 0);

		SDL_PushGPUFragmentUniformData(this.mHandle, uint32(slotIdx), pData, uint32(sizeInBytes));
		return .Ok;
	}


	public Response PushComputeUniformData (int slotIdx, void* pData, int sizeInBytes)
	{
		Debug.Assert(slotIdx >= 0);
		Debug.Assert(pData != null);
		Debug.Assert(sizeInBytes > 0);

		SDL_PushGPUComputeUniformData(this.mHandle, uint32(slotIdx), pData, uint32(sizeInBytes));
		return .Ok;
	}


	public Response BeginRenderPass (Window window, RenderPass renderPass)
	{
		Debug.Assert(renderPass != null);
		Debug.Assert(this.mRenderPass == null);

		var swapchainTexture = window.mSwapchain.AcquireTexture(this).Resolve!();

		this.mRenderPass = renderPass;
		this.mRenderPass.Begin(this, swapchainTexture).Resolve!();

		return .Ok;
	}


	public Response EndRenderPass ()
	{
		Debug.Assert(this.mRenderPass != null);
		Debug.Assert(this.mRenderPass.mHandle != null);

		this.mRenderPass.End(this).Resolve!();
		this.mRenderPass = null;
		this.mGraphicsPipeline = null;

		return .Ok;
	}



	public Response SetPipeline (Pipeline pipeline)
	{
		Debug.Assert(pipeline != null);
		Debug.Assert(this.mRenderPass != null);

		SDL_BindGPUGraphicsPipeline(this.mRenderPass.mHandle, pipeline.mHandle);
		return .Ok;
	}


	public Response SetViewport (Viewport viewport)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_SetGPUViewport(this.mRenderPass.mHandle, &(SDL_GPUViewport)viewport);
		return .Ok;
	}


	public Response SetViewport (int x, int y, int width, int height, float minDepth = 0F, float maxDepth = 1F)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUViewport viewport = SDL_GPUViewport(x, y, width, height, minDepth, maxDepth);
		SDL_SetGPUViewport(this.mRenderPass.mHandle, &viewport);
		return .Ok;
	}


	public Response SetScissor (Scissor scissor)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_SetGPUScissor(this.mRenderPass.mHandle, &(SDL_Rect)scissor);
		return .Ok;
	}


	public Response SetScissor (int x, int y, int width, int height)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_Rect scissor = SDL_Rect(x, y, width, height);
		SDL_SetGPUScissor(this.mRenderPass.mHandle, &scissor);
		return .Ok;
	}


	public Response SetBlendConstants (Color blendConstants)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_SetGPUBlendConstants(this.mRenderPass.mHandle, blendConstants);
		return .Ok;
	}


	public Response SetStencilReference (uint8 reference)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_SetGPUStencilReference(this.mRenderPass.mHandle, reference);
		return .Ok;
	}


	public Response BindVertexBuffer (Buffer buffer, int slotIdx = 0, int offset = 0)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUBufferBinding binding = SDL_GPUBufferBinding(buffer, offset);

		SDL_BindGPUVertexBuffers(this.mRenderPass.mHandle, uint32(slotIdx), &binding, 1);
		return .Ok;
	}


	public Response BindVertexBuffers (int firstSlot, params SDL_GPUBufferBinding[] bindings)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_BindGPUVertexBuffers(this.mRenderPass.mHandle, uint32(firstSlot), bindings.CArray(), uint32(bindings.Count));
		return .Ok;
	}


	public Response BindIndexBuffer (Buffer indexBuffer, Buffer.IndexFormat indexFormat = .UInt32)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUBufferBinding binding = SDL_GPUBufferBinding(indexBuffer, 0);
		SDL_BindGPUIndexBuffer(this.mRenderPass.mHandle, &binding, indexFormat);
		return .Ok;
	}


	public Response BindVertexSamplers (int firstSlot, params Texture[] textures)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUTextureSamplerBinding[] bindings = scope SDL_GPUTextureSamplerBinding[textures.Count];
		for (var n = 0; n < textures.Count; n++)
		{
			Debug.Assert(textures[n] != null);
			Debug.Assert(textures[n].mHandle != null);
			Debug.Assert(textures[n].mSampler != null);
			Debug.Assert(textures[n].mSampler.mHandle != null);

			bindings[n] = SDL_GPUTextureSamplerBinding(textures[n]);
		}

		SDL_BindGPUVertexSamplers(this.mRenderPass.mHandle, uint32(firstSlot), bindings.CArray(), uint32(bindings.Count));
		return .Ok;
	}


	public Response BindVertexStorageTextures (int firstSlot, params Texture[] textures)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUTexture*[] storageTextures = scope SDL_GPUTexture*[textures.Count];
		for (var n = 0; n < textures.Count; n++)
		{
			Debug.Assert(textures[n] != null);
			Debug.Assert(textures[n].mHandle != null);

			storageTextures[n] = textures[n].mHandle;
		}

		SDL_BindGPUVertexStorageTextures(this.mRenderPass.mHandle, uint32(firstSlot), storageTextures.CArray(), uint32(storageTextures.Count));
		return .Ok;
	}


	public Response BindVertexStorageBuffers (int firstSlot, params Buffer[] buffers)
	{
		Debug.Assert(this.mRenderPass != null);
		
		SDL_GPUBuffer*[] storageBuffers = scope SDL_GPUBuffer*[buffers.Count];
		for (var n = 0; n < buffers.Count; n++)
		{
			Debug.Assert(buffers[n] != null);
			Debug.Assert(buffers[n].mHandle != null);

			storageBuffers[n] = buffers[n].mHandle;
		}

		SDL_BindGPUVertexStorageBuffers(this.mRenderPass.mHandle, uint32(firstSlot), storageBuffers.CArray(), uint32(storageBuffers.Count));
		return .Ok;
	}


	public Response BindFragmentSamplers (int firstSlot, params Texture[] textures)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUTextureSamplerBinding[] bindings = scope SDL_GPUTextureSamplerBinding[textures.Count];
		for (var n = 0; n < textures.Count; n++)
		{
			Debug.Assert(textures[n] != null);
			Debug.Assert(textures[n].mHandle != null);
			Debug.Assert(textures[n].mSampler != null);
			Debug.Assert(textures[n].mSampler.mHandle != null);

			bindings[n] = SDL_GPUTextureSamplerBinding(textures[n]);
		}

		SDL_BindGPUFragmentSamplers(this.mRenderPass.mHandle, uint32(firstSlot), bindings.CArray(), uint32(bindings.Count));
		return .Ok;
	}


	public Response BindFragmentStorageTextures (int firstSlot, params Texture[] textures)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_GPUTexture*[] storageTextures = scope SDL_GPUTexture*[textures.Count];
		for (var n = 0; n < textures.Count; n++)
		{
			Debug.Assert(textures[n] != null);
			Debug.Assert(textures[n].mHandle != null);

			storageTextures[n] = textures[n].mHandle;
		}

		SDL_BindGPUFragmentStorageTextures(this.mRenderPass.mHandle, uint32(firstSlot), storageTextures.CArray(), uint32(storageTextures.Count));
		return .Ok;
	}


	public Response BindFragmentStorageBuffers (int firstSlot, params Buffer[] buffers)
	{
		Debug.Assert(this.mRenderPass != null);
		
		SDL_GPUBuffer*[] storageBuffers = scope SDL_GPUBuffer*[buffers.Count];
		for (var n = 0; n < buffers.Count; n++)
		{
			Debug.Assert(buffers[n] != null);
			Debug.Assert(buffers[n].mHandle != null);

			storageBuffers[n] = buffers[n].mHandle;
		}

		SDL_BindGPUFragmentStorageBuffers(this.mRenderPass.mHandle, uint32(firstSlot), storageBuffers.CArray(), uint32(storageBuffers.Count));
		return .Ok;
	}


	public Response DrawIndexedPrimitives (int countIndices, int countInstances, int firstIndex, int vertexOffset, int firstInstance)
	{
		Debug.Assert(this.mRenderPass != null);
		Debug.Assert(this.mGraphicsPipeline != null);

		SDL_DrawGPUIndexedPrimitives(this.mRenderPass.mHandle, uint32(countIndices), uint32(countInstances), uint32(firstIndex), int32(vertexOffset), uint32(firstInstance));
		return .Ok;
	}


	public Response DrawPrimitives (int countVertices, int countInstances, int firstVertex, int firstInstanse)
	{
		Debug.Assert(this.mRenderPass != null);

		SDL_DrawGPUPrimitives(this.mRenderPass.mHandle, uint32(countVertices), uint32(countInstances), uint32(firstVertex), uint32(firstInstanse));
		return .Ok;
	}


	public Response DrawPrimitivesIndirect (Buffer buffer, int offset, int drawCount)
	{
		Debug.Assert(this.mRenderPass != null);
		Debug.Assert(buffer != null);
		Debug.Assert(buffer.mHandle != null);

		SDL_DrawGPUPrimitivesIndirect(this.mRenderPass.mHandle, buffer.mHandle, uint32(offset), uint32(drawCount));
		return .Ok;
	}


	public Response DrawGPUIndexedPrimitivesIndirect (Buffer buffer, int offset, int drawCount)
	{
		Debug.Assert(this.mRenderPass != null);
		Debug.Assert(buffer != null);
		Debug.Assert(buffer.mHandle != null);

		SDL_DrawGPUIndexedPrimitivesIndirect(this.mRenderPass.mHandle, buffer.mHandle, uint32(offset), uint32(drawCount));
		return .Ok;
	}



	public Response<ComputePass> BeginComputePass (SDL_GPUStorageTextureReadWriteBinding[] textures, SDL_GPUStorageBufferReadWriteBinding[] buffers)
	{
		var handle = SDL_BeginGPUComputePass(this.mHandle, textures.CArray(), uint32(textures.Count), buffers.CArray(), uint32(buffers.Count));
		if (handle == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.mComputePass = ComputePass(handle);
		return this.mComputePass.Value;
	}


	public Response SetPipeline (ComputePipeline computePipeline)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		this.mComputePipeline = computePipeline;
		SDL_BindGPUComputePipeline(this.mComputePass.Value.mHandle, computePipeline.mHandle);
		return .Ok;
	}


	public Response BindComputeSamplers (int firstSlot, params SDL_GPUTextureSamplerBinding[] textureSamplers)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		SDL_BindGPUComputeSamplers(this.mComputePass.Value.mHandle, uint32(firstSlot), textureSamplers.CArray(), uint32(textureSamplers.Count));
		return .Ok;
	}


	public Response BindComputeStorageTextures (int firstSlot, params Texture[] textures)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		SDL_GPUTexture*[] storageTextures = scope SDL_GPUTexture*[textures.Count];
		for (var n = 0; n < textures.Count; n++)
		{
			Debug.Assert(textures[n] != null);
			Debug.Assert(textures[n].mHandle != null);

			storageTextures[n] = textures[n].mHandle;
		}

		SDL_BindGPUComputeStorageTextures(this.mComputePass.Value.mHandle, uint32(firstSlot), storageTextures.CArray(), uint32(storageTextures.Count));
		return .Ok;
	}


	public Response BindComputeStorageBuffers (int firstSlot, params Buffer[] buffers)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		SDL_GPUBuffer*[] storageBuffers = scope SDL_GPUBuffer*[buffers.Count];
		for (var n = 0; n < buffers.Count; n++)
		{
			Debug.Assert(buffers[n] != null);
			Debug.Assert(buffers[n].mHandle != null);

			storageBuffers[n] = buffers[n].mHandle;
		}

		SDL_BindGPUComputeStorageBuffers(this.mComputePass.Value.mHandle, uint32(firstSlot), storageBuffers.CArray(), uint32(storageBuffers.Count));
		return .Ok;
	}


	public Response Dispatch (int groupCountX, int groupCountY, int groupCountZ)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);
		
		SDL_DispatchGPUCompute(this.mComputePass.Value.mHandle, uint32(groupCountX), uint32(groupCountY), uint32(groupCountZ));
		return .Ok;
	}


	public Response DispatchIndirect(Buffer buffer, int offset)
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		Debug.Assert(buffer != null);
		Debug.Assert(buffer.mHandle != null);
		
		SDL_DispatchGPUComputeIndirect(this.mComputePass.Value.mHandle, buffer.mHandle, uint32(offset));
		return .Ok;
	}


	public Response EndComputePass ()
	{
		Debug.Assert(this.mComputePass.HasValue);
		Debug.Assert(this.mComputePass.Value.mHandle != null);

		SDL_EndGPUComputePass(this.mComputePass.Value.mHandle);
		this.mComputePass = null;
		return .Ok;
	}



	public Response<CopyPass> BeginCopyPass ()
	{
		SDL_GPUCopyPass* handle = SDL_BeginGPUCopyPass(this.mHandle);
		if (handle == null)
			return new Error()..AppendCStr(SDL_GetError());

		this.mCopyPass = CopyPass(handle);
		return this.mCopyPass.Value;
	}


	public Response EndCopyPass ()
	{
		Debug.Assert(this.mCopyPass.HasValue);
		Debug.Assert(this.mCopyPass.Value.mHandle != null);

		SDL_EndGPUCopyPass(this.mCopyPass.Value.mHandle);
		return .Ok;
	}



	public Response GenerateMipmapsForGPUTexture (Texture texture)
	{
		Debug.Assert(texture != null);
		Debug.Assert(texture.mHandle != null);

		SDL_GenerateMipmapsForGPUTexture(this.mHandle, texture.mHandle);
		return .Ok;
	}


	public Response BlitTexture (SDL_GPUBlitInfo info)
	{
		var info;
		SDL_BlitGPUTexture(this.mHandle, &info);
		return .Ok;
	}
}