namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension Renarelle
{
	public struct Description
	{
		public delegate Response OnInitialize();
		public delegate Response Callback();

		public OnInitialize mOnInitialize;
		public Callback mOnUpdate;
		public Callback mOnShutdown;

		public GraphicsDevice.Backend mGraphicsBackend = .Direct3D11;
		public bool bEnableGraphicsDebugging;

		public SDL3.Raw.SDL_InitFlags mSDLFlags = .SDL_INIT_VIDEO | .SDL_INIT_EVENTS;
		public SDL3.Raw.IMG_InitFlags mIMGFlags = .IMG_INIT_PNG | .IMG_INIT_JPG;
	}
}
