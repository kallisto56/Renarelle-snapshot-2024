namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class KeyEvent : Event
{
	public Window mWindow;
	public EventType mType;
	public SDL_Keycode mKey;
	public SDL_Keymod mModifiers;
	public bool bIsRepeat;

	public enum EventType
	{
		KeyDown,
		KeyUp,
	}


	override public void ToString (String buffer)
	{
		buffer.AppendF("KeyEvent(window: {0}, type: {1}, key: {2}, modifiers: {3}, bIsRepeat: {4});", (void*)mWindow.[Friend]mHandle, mType, mKey, mModifiers, bIsRepeat);
	}
}