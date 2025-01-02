namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;


class Window : RefCounted
{
	internal SDL_Window* mHandle;
	internal Swapchain mSwapchain;
	public Renderer2D mRenderer2D;
	
	public delegate Window.ResponseToClosure OnWindowIsClosingDelegate (Window window);
	public delegate void OnWindowClosedDelegate (Window window);
	public delegate Response OnWindowRenderingDelegate (Window window, Renderer2D renderer);

	public Event<OnWindowIsClosingDelegate> mOnClosing = .() ~ _.Dispose();
	public Event<OnWindowClosedDelegate> mOnClosed = .() ~ _.Dispose();
	public Event<OnWindowRenderingDelegate> mOnRender = .() ~ _.Dispose();

	public Event<OnKeyDownDelegate> mOnKeyDown = .() ~ _.Dispose();
	public Event<OnKeyUpDelegate> mOnKeyUp = .() ~ _.Dispose();

	public Event<OnMouseMoveDelegate> mOnMouseMove = .() ~ _.Dispose();
	public Event<OnMouseDownDelegate> mOnMouseDown = .() ~ _.Dispose();
	public Event<OnMouseUpDelegate> mOnMouseUp = .() ~ _.Dispose();
	public Event<OnMouseWheelDelegate> mOnMouseWheel = .() ~ _.Dispose();

	public bool bIsPendingClosure { get; protected set; };

	public String mTitle { get; protected set; }
	public Color mClearColor = Color.Black();

	public int mX { get; protected set; }
	public int mY { get; protected set; }

	public int mWidth { get; protected set; }
	public int mHeight { get; protected set; }

	public int mMinWidth { get; protected set; }
	public int mMinHeight { get; protected set; }

	public int mMaxWidth { get; protected set; }
	public int mMaxHeight { get; protected set; }

	public bool bIsResizable { get; protected set; };
	public bool bIsClosable { get; protected set; };
	public bool bCanEnterFullScreen { get; protected set; };

	public bool bIsTransparent { get; protected set; };
	public bool bIsBorderless { get; protected set; };

	public bool bIsVisible { get; protected set; };
	public bool bIsInForeground { get; protected set; };
	public bool bIsFullscreen { get; protected set; };
	public bool bIsModal { get; protected set; };


	public this ()
	{
		Self.AddInstance(this);

		this.mSwapchain = new Swapchain();
		this.mRenderer2D = new Renderer2D();
		this.mTitle = new String();
	}


	public ~this ()
	{
		Self.RemoveInstance(this);
		delete this.mSwapchain;

		if (this.mHandle != null)
		{
			Renarelle.sGraphicsDevice.ReleaseWindow(this);
			SDL_DestroyWindow(this.mHandle);
		}

		delete this.mTitle;
		delete this.mRenderer2D;
	}


	public Response Initialize (Self.Description description = Self.Description())
	{
		this.mTitle.Set(description.mTitle);
		this.mClearColor = description.mClearColor;

		this.mX = 0;
		this.mY = 0;
		this.mWidth = description.mWidth;
		this.mHeight = description.mHeight;

		this.mMinWidth = description.mMinWidth;
		this.mMinHeight = description.mMinHeight;

		this.mMaxWidth = description.mMaxWidth;
		this.mMaxHeight = description.mMaxHeight;

		this.bIsResizable = description.bIsResizable;
		this.bIsClosable = description.bIsClosable;
		this.bCanEnterFullScreen = description.bCanEnterFullScreen;

		this.bIsTransparent = description.bIsTransparent;
		this.bIsBorderless = description.bIsBorderless;

		this.bIsVisible = description.bIsVisible;
		this.bIsFullscreen = description.bIsFullscreen;
		this.bIsModal = description.bIsModal;

		SDL_WindowFlags windowFlags = 0;
		if (this.bIsResizable) windowFlags |= .SDL_WINDOW_RESIZABLE;
		if (this.bIsTransparent) windowFlags |= .SDL_WINDOW_TRANSPARENT;
		if (this.bIsBorderless) windowFlags |= .SDL_WINDOW_BORDERLESS;
		if (this.bIsFullscreen) windowFlags |= .SDL_WINDOW_FULLSCREEN;
		if (this.bIsModal) windowFlags |= .SDL_WINDOW_MODAL;
		if (this.bIsVisible == false) windowFlags |= .SDL_WINDOW_HIDDEN;

		this.mHandle = SDL_CreateWindow(this.mTitle.CStr(), int32(this.mWidth), int32(this.mHeight), windowFlags);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		Renarelle.sGraphicsDevice.ClaimWindow(this).Resolve!();
		this.mSwapchain.Initialize(this, description.mSwapchainPresentMode, description.mSwapchainComposition).Resolve!();

		this.mRenderer2D.Initialize(Renderer2D.Description() {
			mWindow = this,
			mRenderPass = Renarelle.sDefaultRenderPass,
		}).Resolve!();

		this.GetCurrentPosition();
		this.GetCurrentSize();

		return default;
	}


	public void SetTitle (StringView title)
	{
		this.mTitle.Set(title);
		SDL_SetWindowTitle(this.mHandle, this.mTitle.CStr());
	}


	public void Show ()
	{
		SDL_ShowWindow(this.mHandle);
		this.bIsVisible = true;
	}


	public void Hide ()
	{
		SDL_HideWindow(this.mHandle);
		this.bIsVisible = false;
	}


	public void Close (bool bForceClose = false)
	{
		if (bForceClose == false)
		{
			if (this.bIsClosable == false || this.mOnClosing.Invoke(this) == .Cancel)
				return;
		}
		
		this.mOnClosed.Invoke(this);
		this.bIsPendingClosure = true;

		Renarelle.sGraphicsDevice.ReleaseWindow(this);

		if (SDL_HideWindow(this.mHandle) == false)
			Debug.Warning!(StringView(SDL_GetError()));
	}


	public float GetAspectRatio ()
	{
		return float(this.mWidth) / float(this.mHeight);
	}


	void GetCurrentPosition ()
	{
		int32 x = ?;
		int32 y = ?;
		SDL_GetWindowPosition(this.mHandle, &x, &y);
		this.mX = x;
		this.mY = y;
	}


	void GetCurrentSize ()
	{
		int32 width = ?;
		int32 height = ?;
		SDL_GetWindowSize(this.mHandle, &width, &height);
		this.mWidth = width;
		this.mHeight = height;
	}
}