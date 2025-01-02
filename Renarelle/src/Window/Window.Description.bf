namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;


extension Window
{
	public struct Description
	{
		public StringView mTitle;

		public Color mClearColor = Color(0.25F, 0.25F, 0.25F, 1.0F);

		public int mWidth = 800;
		public int mHeight = 640;

		public int mMinWidth = 320;
		public int mMinHeight = 240;

		public int mMaxWidth = uint16.MaxValue;
		public int mMaxHeight = uint16.MaxValue;

		public bool bIsResizable = true;
		public bool bIsClosable = true;
		public bool bIsMinimizable = true;
		public bool bIsMaximizable = true;
		public bool bCanEnterFullScreen = true;

		public bool bIsTransparent = false;
		public bool bIsBorderless = false;

		public bool bIsVisible = true;
		public bool bIsFullscreen = false;
		public bool bIsCentered = true;
		public bool bIsModal = false;

		public SDL_GPUPresentMode mSwapchainPresentMode = Swapchain.cDefaultPresentMode;
		public SDL_GPUSwapchainComposition mSwapchainComposition = Swapchain.cDefaultComposition;
	}
}
