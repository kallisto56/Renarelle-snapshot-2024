namespace Renarelle;


using System;
using System.IO;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class Shader : RefCounted
{
	public SDL_GPUShader* mHandle { get; protected set; }

	public String mFileName { get; protected set; }
	public String mEntryPoint { get; protected set; }
	public SDL_GPUShaderStage mStage { get; protected set; }

	public int mCountSamples { get; protected set; }
	public int mCountStorageTextures { get; protected set; }
	public int mCountStorageBuffers { get; protected set; }
	public int mCountUniformatBuffers { get; protected set; }


	public this ()
	{
		this.mFileName = new String();
		this.mEntryPoint = new String();
	}


	public Response Initialize (Self.Description description)
	{
		this.mFileName.Set(description.mFileName);
		this.mEntryPoint.Set(description.mEntryPoint);

		this.mStage = description.mStage;
		
		this.mCountSamples = description.mCountSamples;
		this.mCountStorageTextures = description.mCountStorageTextures;
		this.mCountStorageBuffers = description.mCountStorageBuffers;
		this.mCountUniformatBuffers = description.mCountUniformatBuffers;

		List<uint8> fileContent = scope List<uint8>();
		if (File.ReadAll(this.mFileName, fileContent) case .Err(let error))
			return new Error()..AppendF("Failed to read file located at \"{}\"; IO error: {};", this.mFileName, error);

		SDL_GPUShaderCreateInfo createInfo = SDL_GPUShaderCreateInfo()
		{
			code_size = c_size(fileContent.Count),
			code = fileContent.Ptr,
			entrypoint = this.mEntryPoint.CStr(),
			format = Renarelle.sGraphicsDevice.mShaderFormat,
			stage = this.mStage,
			num_samplers = uint32(this.mCountSamples),
			num_storage_textures = uint32(this.mCountStorageTextures),
			num_storage_buffers = uint32(this.mCountStorageBuffers),
			num_uniform_buffers = uint32(this.mCountUniformatBuffers),
		};

		this.mHandle = SDL_CreateGPUShader(Renarelle.sGraphicsDevice.mHandle, &createInfo);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	public ~this ()
	{
		delete this.mFileName;
		delete this.mEntryPoint;

		if (this.mHandle != null)
			SDL_ReleaseGPUShader(Renarelle.sGraphicsDevice.mHandle, this.mHandle);
	}
}