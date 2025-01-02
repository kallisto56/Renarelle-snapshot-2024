namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Threading;
using System.Math;
using SDL3.Raw;

using internal Renarelle.GraphicsDevice;
using internal Renarelle.Window;
using internal Renarelle.Swapchain;
using internal Renarelle.Pipeline;
using internal Renarelle.Buffer;
using internal Renarelle.Input;


static class Renarelle
{
	static public GraphicsDevice sGraphicsDevice;
	static public RenderPass sDefaultRenderPass;
	static public Sampler sPointSampler;
	static public Sampler sSmoothSampler;
	static public FontLibrary sFontLibrary;
	static public bool bIsPendingClosure = false;

	static Self.Description sDescription;


	static public Response Initialize (Self.Description description)
	{
		Self.sDescription = description;

		if (SDL_Init(description.mSDLFlags) == false)
			return new Error()..AppendCStr(SDL_GetError());

		IMG_Init(description.mIMGFlags);

		GraphicsDevice.Description graphicsDeviceDescription = GraphicsDevice.Description()
		{
			mGraphicsBackend = Self.sDescription.mGraphicsBackend,
			bEnableDebugging = Self.sDescription.bEnableGraphicsDebugging,
		};
		Self.sGraphicsDevice = new GraphicsDevice();
		Self.sGraphicsDevice.Initialize(graphicsDeviceDescription).Resolve!();

		Self.sDefaultRenderPass = new RenderPass();
		Self.sDefaultRenderPass.Initialize(RenderPass.Description() {
			mColorAttachments = new RenderPass.ColorAttachment[] (
				RenderPass.ColorAttachment() {
					mClearColor = Color(0.20F, 0.20F, 0.20F, 1.0F),
					mLoadOp = .SDL_GPU_LOADOP_CLEAR,
					mStoreOp = .SDL_GPU_STOREOP_STORE,
				},
			),
		}).Resolve!();

		Self.sPointSampler = new Sampler();
		Self.sPointSampler.Initialize().Resolve!();

		Self.sSmoothSampler = new Sampler();
		Self.sSmoothSampler.Initialize().Resolve!();

		Self.sFontLibrary = new FontLibrary(true);
		Self.sFontLibrary.Initialize().Resolve!();

		Self.sDescription.mOnInitialize().Resolve!();

		return .Ok;
	}


	static public Response Run (Self.Description description)
	{
		Self.Initialize(description).Resolve!();
		Self.Run().Resolve!();

		return .Ok;
	}


	static public Response Run ()
	{
		while (Self.bIsPendingClosure == false)
		{
			Input.Update();
			Window.PollEvents().Resolve!();
			Self.sDescription.mOnUpdate().Resolve!();

			Window.RenderAll().Resolve!();
		}

		Self.Shutdown().Resolve!();

		return .Ok;
	}


	static public Response Shutdown ()
	{
		if (Self.sGraphicsDevice?.bIsInitialized == true)
			Self.sGraphicsDevice.WaitForIdle().Resolve!();

		Self.sDescription.mOnShutdown().Resolve!();

		Self.sDefaultRenderPass?.ReleaseRef();
		Self.sPointSampler?.ReleaseRef();
		Self.sSmoothSampler?.ReleaseRef();
		if (Self.sGraphicsDevice?.bIsInitialized == true)
			Self.sGraphicsDevice.ReleaseRef();

		IMG_Quit();
		SDL_Quit();

		delete Self.sFontLibrary;

		return .Ok;
	}
}