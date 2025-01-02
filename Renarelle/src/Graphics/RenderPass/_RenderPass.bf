namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;

using SDL3.Raw;


struct RenderPass : IDisposable
{
	public SDL_GPURenderPass* mHandle;
	public CommandBuffer mCommandBuffer;

	public Viewport? mViewport = null;
	public SDL_Rect? mScissor = null;
	public Pipeline mPipeline = null;
	public Buffer mIndexBuffer = null;
	public Buffer mVertexBuffer = null;


	public this (CommandBuffer commandBuffer, SDL_GPURenderPass* renderPass)
	{
		this.mHandle = renderPass;
		this.mCommandBuffer = commandBuffer;
	}


	public void EndRenderPass ()
	{
		SDL_EndGPURenderPass(this.mHandle);

		// TODO: This is bad
		this.mCommandBuffer.mRenderPass = null;
	}


	public void Dispose ()
	{
		this.EndRenderPass();
	}


	public void SetViewport (Viewport v) mut
	{
		this.mViewport = v;
		SDL_GPUViewport viewport = this.mViewport.Value;
		SDL_SetGPUViewport(this.mHandle, &viewport);
	}


	public void SetViewport(int x, int y, int width, int height, int minDepth, int maxDepth) mut
	{
		this.mViewport = Viewport(x, y, width, height, minDepth, maxDepth);
		SDL_GPUViewport parameter = this.mViewport.Value;
		SDL_SetGPUViewport(this.mHandle, &parameter);
	}


	public void SetScissors (int index, Scissors scissors) mut
	{
		this.mScissor = scissors;
		SDL_Rect parameter = this.mScissor.Value;
		SDL_SetGPUScissor(this.mHandle, &parameter);
	}


	public void SetScissors (int index, int x, int y, int width, int height) mut
	{
		this.mScissor = SDL_Rect(x, y, width, height);
		var scissor = this.mScissor.Value;
		SDL_SetGPUScissor(this.mHandle, &scissor);
	}


	public void SetPipeline (Pipeline pipeline) mut
	{
		this.mPipeline = pipeline;
		SDL_BindGPUGraphicsPipeline(this.mHandle, pipeline.mHandle);
	}


	public void BindIndexBuffer (Buffer buffer, int offset, SDL_GPUIndexElementSize indexElementsize) mut
	{
		SDL_GPUBufferBinding binding = SDL_GPUBufferBinding(buffer, offset);
		SDL_BindGPUIndexBuffer(this.mHandle, &binding, indexElementsize);
		this.mIndexBuffer = buffer;
	}


	public void BindVertexBuffers (int firstSlot, params SDL_GPUBufferBinding[] bindings) mut
	{
		SDL_BindGPUVertexBuffers(this.mHandle, uint32(firstSlot), bindings.CArray(), uint32(bindings.Count));
	}


	public void BindVertexBuffer (int slotIdx, int offset, Buffer buffer) mut
	{
		SDL_GPUBufferBinding bindings = SDL_GPUBufferBinding(buffer, offset);
		SDL_BindGPUVertexBuffers(this.mHandle, uint32(slotIdx), &bindings, 1);
		this.mVertexBuffer = buffer;
	}


	public void BindVertexBufferTexture (Texture texture, Sampler sampler)
	{
		SDL_GPUTextureSamplerBinding bindings = SDL_GPUTextureSamplerBinding()
		{
			texture = texture.mHandle,
			sampler = sampler.mHandle,
		};

		SDL_BindGPUVertexSamplers(this.mHandle, 0, &bindings, 1);
	}


	public void BindFragmentBufferTexture (Texture texture, Sampler sampler)
	{
		SDL_GPUTextureSamplerBinding bindings = SDL_GPUTextureSamplerBinding()
		{
			texture = texture.mHandle,
			sampler = sampler.mHandle,
		};

		SDL_BindGPUFragmentSamplers(this.mHandle, 0, &bindings, 1);
	}

	public void DrawPrimitives(uint32 countVertices, uint32 countInstances, uint32 firstVertex, uint32 firstInstance)
	{
		SDL_DrawGPUPrimitives(this.mHandle, uint32(countVertices), uint32(countInstances), uint32(firstVertex), uint32(firstInstance));
	}


	public void DrawIndexed (int num_indices, int num_instances, int first_index, int vertex_offset, int first_instance)
	{
		SDL_DrawGPUIndexedPrimitives(this.mHandle, uint32(num_indices), uint32(num_instances), uint32(first_index), int32(vertex_offset), uint32(first_instance));
	}
}