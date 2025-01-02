namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using System.Interop;
using System.Threading;
using SDL3.Raw;


extension Window
{
	static List<Window> sInstances = new List<Window>() ~ delete _;
	static Monitor sInstancesMonitor = new Monitor() ~ delete _;


	static internal Response PollEvents ()
	{
		Self.sInstancesMonitor.Enter();
		defer Self.sInstancesMonitor.Exit();

		SDL_Event event = ?;
		while (SDL_PollEvent(&event) != false)
		{
			SDL_EventType eventType = (SDL_EventType)event.type;
			var handle = SDL_GetWindowFromEvent(&event);
			var window = Self.FindByHandle(handle);

			if (eventType == .SDL_EVENT_MOUSE_MOTION)
			{
				MouseEvent e = scope MouseEvent()
				{
					mWindow = window,
					mPosition = Vector2(event.motion.x, event.motion.y),
					mDirection = Vector2(event.motion.xrel, event.motion.yrel),
					mButtons = (.)event.motion.state,
					mWheel = Vector2(event.wheel.x, event.wheel.y),
				};

				if (window.mOnMouseMove.HasListeners)
					window.mOnMouseMove.Invoke(e);
			}
			else if (eventType == .SDL_EVENT_MOUSE_BUTTON_DOWN)
			{
				MouseEvent e = scope MouseEvent()
				{
					mWindow = window,
					mPosition = Vector2(event.motion.x, event.motion.y),
					mDirection = Vector2(event.motion.xrel, event.motion.yrel),
					mButtons = (.)event.motion.state,
					mWheel = Vector2(event.wheel.x, event.wheel.y),
				};

				if (window.mOnMouseDown.HasListeners)
					window.mOnMouseDown.Invoke(e);
			}
			else if (eventType == .SDL_EVENT_MOUSE_BUTTON_UP)
			{
				MouseEvent e = scope MouseEvent()
				{
					mWindow = window,
					mPosition = Vector2(event.motion.x, event.motion.y),
					mDirection = Vector2(event.motion.xrel, event.motion.yrel),
					mButtons = (.)event.motion.state,
					mWheel = Vector2(event.wheel.x, event.wheel.y),
				};

				if (window.mOnMouseUp.HasListeners)
					window.mOnMouseUp.Invoke(e);
			}
			else if (eventType == .SDL_EVENT_MOUSE_WHEEL)
			{
				MouseEvent e = scope MouseEvent()
				{
					mWindow = window,
					mPosition = Vector2(event.motion.x, event.motion.y),
					mDirection = Vector2(event.motion.xrel, event.motion.yrel),
					mButtons = (.)event.motion.state,
					mWheel = Vector2(event.wheel.x, event.wheel.y),
				};

				if (window.mOnMouseWheel.HasListeners)
					window.mOnMouseWheel.Invoke(e);
			}
			else if (eventType == .SDL_EVENT_KEY_DOWN || eventType == .SDL_EVENT_KEY_UP)
			{
				KeyEvent e = scope KeyEvent()
				{
					mWindow = window,
					mType = (event.key.type == .SDL_EVENT_KEY_DOWN) ? .KeyDown : .KeyUp,
					mKey = event.key.key,
					mModifiers = (.)event.key.mod,
					bIsRepeat = event.key.repeat_,
				};

				if (e.mType == .KeyDown && window.mOnKeyDown.HasListeners)
				{
					window.mOnKeyDown.Invoke(e);
				}
				else if (window.mOnKeyUp.HasListeners)
				{
					window.mOnKeyUp.Invoke(e);
				}
			}

			if (eventType == .SDL_EVENT_WINDOW_RESIZED)
			{
				window.mWidth = event.window.data1;
				window.mHeight = event.window.data2;
			}
			else if (eventType == .SDL_EVENT_WINDOW_SHOWN)
			{
				window.bIsVisible = true;
			}
			else if (eventType == .SDL_EVENT_WINDOW_HIDDEN)
			{
				window.bIsVisible = false;
			}
			else if (eventType == .SDL_EVENT_DID_ENTER_FOREGROUND)
			{
				window.bIsInForeground = true;
			}
			else if (eventType == .SDL_EVENT_DID_ENTER_BACKGROUND)
			{
				window.bIsInForeground = false;
			}
			else if (eventType == .SDL_EVENT_WINDOW_CLOSE_REQUESTED)
			{
				window.Close();
			}
		}

		return .Ok;
	}


	static internal Response RenderAll ()
	{
		using (Self.sInstancesMonitor.Enter())
		{
			for (var n = 0; n < Self.sInstances.Count; n++)
			{
				Window window = Self.sInstances[n];
				if (window.bIsPendingClosure == false)
				{
					window.mRenderer2D.Prepare();
					window.mOnRender.Invoke(window, window.mRenderer2D).Resolve!();
					window.mRenderer2D.Flush().Resolve!();
				}
			}
		}

		return .Ok;
	}


	static Window FindByHandle (SDL_Window* handle)
	{
		if (handle == null)
			return null;

		for (var n = 0; n < Self.sInstances.Count; n++)
		{
			var instance = Self.sInstances[n];
			if (instance.mHandle == handle)
				return instance;
		}

		Runtime.FatalError("BUG: Unable to find window with specified handle.");
	}


	static void AddInstance (Window window)
	{
		using (Self.sInstancesMonitor.Enter())
			Self.sInstances.Add(window);
	}


	static void RemoveInstance (Window window)
	{
		using (Self.sInstancesMonitor.Enter())
			Self.sInstances.Remove(window);
	}
}
