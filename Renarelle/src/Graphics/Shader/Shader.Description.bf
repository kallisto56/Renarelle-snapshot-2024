namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Shader
{
	public struct Description
	{
		public StringView mFileName;
		public StringView mEntryPoint = "main";

		public SDL_GPUShaderStage mStage;

		public int mCountSamples = 0;
		public int mCountStorageTextures = 0;
		public int mCountStorageBuffers = 0;
		public int mCountUniformatBuffers = 0;
	}
}
