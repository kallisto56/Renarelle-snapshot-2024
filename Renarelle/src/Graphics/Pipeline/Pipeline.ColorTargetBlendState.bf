namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Pipeline
{
	public struct ColorTargetBlendState
	{
		public bool mBlendEnabled;
		public SDL_GPUColorComponentFlags? mColorWriteMask;
		public SDL_GPUBlendFactor mSourceColorFactor;
		public SDL_GPUBlendFactor mDestinationColorFactor;
		public SDL_GPUBlendOp mColorFunction;
		public SDL_GPUBlendFactor mSourceAlphaFactor;
		public SDL_GPUBlendFactor mDestinationAlphaFactor;
		public SDL_GPUBlendOp mAlphaFunction;


		static readonly public ColorTargetBlendState OverrideBlend = ColorTargetBlendState
		{
		    mBlendEnabled = true,
		    mSourceColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mDestinationColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ZERO,
		    mColorFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		    mSourceAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mDestinationAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ZERO,
		    mAlphaFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		};


		static readonly public ColorTargetBlendState AlphaBlend = ColorTargetBlendState
		{
		    mBlendEnabled = true,
		    mSourceColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_SRC_ALPHA,
		    mDestinationColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_ALPHA,
		    mColorFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		    mSourceAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_SRC_ALPHA,
		    mDestinationAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE_MINUS_SRC_COLOR,
		    mAlphaFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		};


		static readonly public ColorTargetBlendState AdditiveBlend = ColorTargetBlendState
		{
		    mBlendEnabled = true,
		    mSourceColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_SRC_ALPHA,
		    mDestinationColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mColorFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		    mSourceAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_SRC_ALPHA,
		    mDestinationAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mAlphaFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		};


		static readonly public ColorTargetBlendState Disabled = ColorTargetBlendState
		{
		    mBlendEnabled = false,
		    mSourceColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mDestinationColorFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ZERO,
		    mColorFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		    mSourceAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ONE,
		    mDestinationAlphaFactor = SDL_GPUBlendFactor.SDL_GPU_BLENDFACTOR_ZERO,
		    mAlphaFunction = SDL_GPUBlendOp.SDL_GPU_BLENDOP_ADD,
		};


		static public implicit operator SDL_GPUColorTargetBlendState (ColorTargetBlendState e)
		{
			SDL_GPUColorComponentFlags colorMask = .SDL_GPU_COLORCOMPONENT_R | .SDL_GPU_COLORCOMPONENT_G | .SDL_GPU_COLORCOMPONENT_B | .SDL_GPU_COLORCOMPONENT_A;
			if (e.mColorWriteMask.HasValue)
				colorMask = e.mColorWriteMask.Value;

			return SDL_GPUColorTargetBlendState()
			{
				src_color_blendfactor = e.mSourceColorFactor,
				dst_color_blendfactor = e.mDestinationColorFactor,
				color_blend_op = e.mColorFunction,
				src_alpha_blendfactor = e.mSourceAlphaFactor,
				dst_alpha_blendfactor = e.mDestinationAlphaFactor,
				alpha_blend_op = e.mAlphaFunction,
				color_write_mask = colorMask,
				enable_blend = e.mBlendEnabled,
				enable_color_write_mask = e.mColorWriteMask.HasValue,
			};
		}
	}
}
