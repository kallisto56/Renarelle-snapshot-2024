namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class RenderPass : RefCounted
{
	public SDL_GPURenderPass* mHandle { get; protected set; }

	public Self.Description mDescription;


	public Response Initialize (RenderPass.Description description)
	{
		this.mDescription = description;

		return .Ok;
	}


	public ~this ()
	{
		this.mDescription.Dispose();
	}


	public Response Begin (CommandBuffer commandBuffer, Texture.View swapchainTexture)
	{
		var colorTargets = scope SDL_GPUColorTargetInfo[this.mDescription.mColorAttachments.Count];
		for (var n = 0; n < colorTargets.Count; n++)
		{
			colorTargets[n] = this.mDescription.mColorAttachments[n];
			if (colorTargets[n].texture == null)
				colorTargets[n].texture = swapchainTexture.mHandle;
		}

		SDL_GPUDepthStencilTargetInfo depthAttachment;
		SDL_GPUDepthStencilTargetInfo* depthStencilTarget = null;
		if (this.mDescription.mDepthAttachment.HasValue)
		{
			depthAttachment = this.mDescription.mDepthAttachment.Value;
			depthStencilTarget = &depthAttachment;
		}

		this.mHandle = SDL_BeginGPURenderPass(commandBuffer.mHandle, colorTargets.CArray(), uint32(colorTargets.Count), depthStencilTarget);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	public Response End (CommandBuffer commandBuffer)
	{
		SDL_EndGPURenderPass(this.mHandle);
		this.mHandle = null;
		return .Ok;
	}
}