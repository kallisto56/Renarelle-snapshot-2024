namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class MouseEvent : Event
{
	public Window mWindow;
	public Vector2 mPosition;
	public Vector2 mDirection;
	public Vector2 mWheel;
	public Input.MouseButton mButtons;


	override public void ToString (String buffer)
	{
		buffer.AppendF("MouseEvent(window: {0}, position: {1}, direction: {2}, state: {3});", (void*)mWindow.[Friend]mHandle, mPosition, mDirection, mButtons);
	}
}