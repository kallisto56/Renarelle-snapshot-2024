namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class Sampler : RefCounted
{
	public SDL_GPUSampler* mHandle { get; protected set; }


	public Response Initialize ()
	{
		SDL_GPUSamplerCreateInfo createInfo = SDL_GPUSamplerCreateInfo()
		{
			min_filter = .SDL_GPU_FILTER_LINEAR, /**< The minification filter to apply to lookups. */
			mag_filter = .SDL_GPU_FILTER_LINEAR, /**< The magnification filter to apply to lookups. */
			mipmap_mode = .SDL_GPU_SAMPLERMIPMAPMODE_LINEAR, /**< The mipmap filter to apply to lookups. */
			address_mode_u = 0, /**< The addressing mode for U coordinates outside [0, 1). */
			address_mode_v = 0, /**< The addressing mode for V coordinates outside [0, 1). */
			address_mode_w = 0, /**< The addressing mode for W coordinates outside [0, 1). */
			mip_lod_bias = 0, /**< The bias to be added to mipmap LOD calculation. */
			max_anisotropy = 0, /**< The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored. */
			compare_op = .SDL_GPU_COMPAREOP_LESS, /**< The comparison operator to apply to fetched data before filtering. */
			min_lod = 0, /**< Clamps the minimum of the computed LOD value. */
			max_lod = 1, /**< Clamps the maximum of the computed LOD value. */
			enable_anisotropy = false, /**< true to enable anisotropic filtering. */
			enable_compare = false, /**< true to enable comparison against a reference value during lookups. */
		};

		this.mHandle = SDL_CreateGPUSampler(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error().AppendCStr(SDL_GetError());

		return .Ok;
	}


	public ~this ()
	{
		if (this.mHandle != null)
			SDL_ReleaseGPUSampler(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
	}
}