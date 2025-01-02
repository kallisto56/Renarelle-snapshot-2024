namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;


class Pipeline : RefCounted
{
	public SDL_GPUGraphicsPipeline* mHandle { get; protected set; }
	public Self.Description mDescription { get; protected set; }


	public Response Initialize (Self.Description description)
	{
		this.mDescription = description;

		SDL_GPUGraphicsPipelineCreateInfo createInfo = SDL_GPUGraphicsPipelineCreateInfo()
		{
			vertex_shader = this.mDescription.mVertexShader.mHandle,
			fragment_shader = this.mDescription.mFragmentShader.mHandle,

			vertex_input_state = this.GetVertexInputState(),
			primitive_type = this.mDescription.mPrimitiveType,
			rasterizer_state = this.mDescription.mRasterizerState,
			multisample_state = this.mDescription.mMultisampleState,
			depth_stencil_state = this.mDescription.mDepthStencilState,
			target_info = this.GetTargetInfo(),
		};

		this.mHandle = SDL_CreateGPUGraphicsPipeline(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	SDL_GPUVertexInputState GetVertexInputState ()
	{
		SDL_GPUVertexInputState state = SDL_GPUVertexInputState()
		{
			vertex_buffer_descriptions = this.mDescription.mVertexInputState.mBuffers.CArray(),
			num_vertex_buffers = uint32(this.mDescription.mVertexInputState.mBuffers.Count),

			vertex_attributes = this.mDescription.mVertexInputState.mAttributes.CArray(),
			num_vertex_attributes = uint32(this.mDescription.mVertexInputState.mAttributes.Count),
		};

		return state;
	}


	SDL_GPUGraphicsPipelineTargetInfo GetTargetInfo ()
	{
		SDL_GPUTextureFormat depthStencilFormat = .SDL_GPU_TEXTUREFORMAT_INVALID;
		bool bHasDepthStencilFormat = false;
		if (this.mDescription.mTargetInfo.mDepthStencilFormat.HasValue)
		{
			depthStencilFormat = this.mDescription.mTargetInfo.mDepthStencilFormat.Value;
			bHasDepthStencilFormat = true;
		}

		return SDL_GPUGraphicsPipelineTargetInfo()
		{
			color_target_descriptions = this.mDescription.mTargetInfo.mColorTargets.CArray(),
			num_color_targets = uint32(this.mDescription.mTargetInfo.mColorTargets.Count),
			depth_stencil_format = depthStencilFormat,
			has_depth_stencil_target = bHasDepthStencilFormat,
		};
	}


	public ~this ()
	{
		if (this.mHandle != null)
		{
			SDL_ReleaseGPUGraphicsPipeline(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
		}

		this.mDescription.Dispose();
	}
}