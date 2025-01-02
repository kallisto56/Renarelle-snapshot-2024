namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


/*
uint32 SDL_GPUTextureFormatTexelBlockSize(SDL_GPUTextureFormat format);
c_bool SDL_GPUTextureSupportsFormat(SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUTextureType type, SDL_GPUTextureUsageFlags usage);
c_bool SDL_GPUTextureSupportsSampleCount(SDL_GPUDevice* device, SDL_GPUTextureFormat format, SDL_GPUSampleCount sample_count);
uint32 SDL_CalculateGPUTextureFormatSize(SDL_GPUTextureFormat format, uint32 width, uint32 height, uint32 depth_or_layer_count);
*/


class Texture : RefCounted
{
	public SDL_GPUTexture* mHandle { get; protected set; }
	public SDL_GPUTextureType mType { get; protected set; }
	public SDL_GPUTextureFormat mFormat { get; protected set; }
	public SDL_GPUTextureUsageFlags mUsageFlags { get; protected set; }
	public int mWidth { get; protected set; }
	public int mHeight { get; protected set; }
	public int mDepth { get; protected set; }
	public int mCountLayers { get; protected set; }
	public int mCountSamplesPerTexel { get; protected set; }
	public int mCountMipLevels { get; protected set; }
	public Sampler mSampler;


	public Response Initialize (Self.Description description)
	{
		this.mType = description.mType;
		this.mFormat = description.mFormat;
		this.mUsageFlags = description.mUsage;

		this.mWidth = description.mWidth;
		this.mHeight = description.mHeight;
		this.mDepth = description.mDepth;

		this.mCountLayers = description.mCountLayers;
		this.mCountSamplesPerTexel = description.mCountSamplesPerTexel;
		this.mCountMipLevels = description.mCountMipLevels;

		this.mSampler = description.mSampler;

		uint32 countLayersOrDepth = uint32(this.mCountLayers);
		if (this.mType == .SDL_GPU_TEXTURETYPE_3D)
			countLayersOrDepth = uint32(this.mDepth);

		var countSamples = FormatHelpers.CountSamples(this.mCountSamplesPerTexel).Resolve!();

		SDL_GPUTextureCreateInfo createInfo = SDL_GPUTextureCreateInfo()
		{
			type = this.mType, /**< The base dimensionality of the texture. */
			format = this.mFormat, /**< The pixel format of the texture. */
			usage = this.mUsageFlags, /**< How the texture is intended to be used by the client. */
			width = uint32(this.mWidth), /**< The width of the texture. */
			height = uint32(this.mHeight), /**< The height of the texture. */
			layer_count_or_depth = countLayersOrDepth, /**< The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures. */
			num_levels = uint32(this.mCountMipLevels), /**< The number of mip levels in the texture. */
			sample_count = countSamples, /**< The number of samples per texel. Only applies if the texture is used as a render target. */

			props = 0, /**< A properties ID for extensions. Should be 0 if no extensions are needed. */
		};

		this.mHandle = SDL_CreateGPUTexture(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	public ~this ()
	{
		if (this.mHandle != null)
			SDL_ReleaseGPUTexture(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
	}


	public Response Write (Image image, TransferBuffer transferBuffer = null)
	{
		var transferBuffer;
		defer { transferBuffer.ReleaseRef(); }

		if (transferBuffer == null)
		{
			transferBuffer = new TransferBuffer();
			transferBuffer.Initialize(image.mSizeInBytes, .Upload).Resolve!();
		}

		transferBuffer.Map().Resolve!();
		Internal.MemCpy(transferBuffer.mPtr, image.CArray(), image.mSizeInBytes);
		transferBuffer.Unmap();

		var commandBuffer = Renarelle.sGraphicsDevice.AcquireCommandBuffer().Resolve!();

		var copyPass = SDL_BeginGPUCopyPass(commandBuffer.mHandle);
		if (copyPass == null)
			return new Error()..AppendCStr(SDL_GetError());

		SDL_GPUTextureTransferInfo source = SDL_GPUTextureTransferInfo()
		{
			transfer_buffer = transferBuffer.mHandle,
			//pixels_per_row = uint32(image.mHandle.pitch),
			//rows_per_layer = uint32(image.mHeight),
			//offset = 0,
		};

		SDL_GPUTextureRegion destination = SDL_GPUTextureRegion()
		{
			texture = this.mHandle,
			mip_level = 0,
			layer = 0,

			x = 0,
			y = 0,
			z = 0,

			w = uint32(this.mWidth),
			h = uint32(this.mHeight),
			d = 1,
		};

		SDL_UploadToGPUTexture(copyPass, &source, &destination, false);
		SDL_EndGPUCopyPass(copyPass);

		Renarelle.sGraphicsDevice.Submit(commandBuffer).Resolve!()
			.WaitFor().Resolve!();

		return .Ok;
	}


	public Response Write (void* pData, int sizeInBytes, TransferBuffer transferBuffer = null)
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

		SDL_GPUTextureTransferInfo source = SDL_GPUTextureTransferInfo()
		{
			transfer_buffer = transferBuffer.mHandle,
		};

		SDL_GPUTextureRegion destination = SDL_GPUTextureRegion()
		{
			texture = this.mHandle,
			mip_level = 0,
			layer = 0,

			x = 0,
			y = 0,
			z = 0,

			w = uint32(this.mWidth),
			h = uint32(this.mHeight),
			d = 1,
		};

		SDL_UploadToGPUTexture(copyPass, &source, &destination, false);
		SDL_EndGPUCopyPass(copyPass);

		Renarelle.sGraphicsDevice.Submit(commandBuffer).Resolve!()
			.WaitFor().Resolve!();

		return .Ok;
	}

	static public Response<Texture> LoadTexture (StringView fileName, Sampler sampler)
	{
		var image = scope Image();
		image.Initialize(Image.Description() {
			mFileName = fileName,
			mDesiredPixelFormat = .SDL_PIXELFORMAT_RGBA32,
		}).Resolve!();

		var texture = new Texture();
		texture.Initialize(Texture.Description() {
			mWidth = image.mWidth,
			mHeight = image.mHeight,
			mUsage = .SDL_GPU_TEXTUREUSAGE_SAMPLER,
			mFormat = .SDL_GPU_TEXTUREFORMAT_R8G8B8A8_UNORM,
			mSampler = sampler,
		}).Resolve!();

		texture.Write(image).Resolve!();

		return texture;
	}
}