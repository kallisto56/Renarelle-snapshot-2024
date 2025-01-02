namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Input
{
	static public Vector2 MousePosition { get; protected set; }
	static MouseButton sMouseButtonFlags;


	static void UpdateMouse ()
	{
		Self.sMouseButtonFlags = (.)SDL_GetMouseState(&Input.MousePosition.mValues[0], &Input.MousePosition.mValues[1]);
	}


	static public bool IsPressed (MouseButton key)
	{
		//Debug.WriteLine("WARNING: {} == {}", key, Self.sMouseButtonFlags.HasFlag(key));
		return Self.sMouseButtonFlags.HasFlag(key);
	}


	[NoShow]
	public enum MouseButton : uint32
	{
		Left     = uint32(1u << (uint32(SDL_MouseButtonFlags.SDL_BUTTON_LEFT) - 1)),
		Middle   = uint32(SDL_MouseButtonFlags.SDL_BUTTON_MIDDLE),
		Right    = uint32(SDL_MouseButtonFlags.SDL_BUTTON_RIGHT),
		X1       = uint32(SDL_MouseButtonFlags.SDL_BUTTON_X1),
		X2       = uint32(SDL_MouseButtonFlags.SDL_BUTTON_X2),
	}
}