namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


public delegate void OnMouseEnterDelegate (MouseEvent e);
public delegate void OnMouseMoveDelegate (MouseEvent e);
public delegate void OnMouseLeaveDelegate (MouseEvent e);
public delegate void OnMouseDownDelegate (MouseEvent e);
public delegate void OnMouseWheelDelegate (MouseEvent e);
public delegate void OnMouseUpDelegate (MouseEvent e);

public delegate void OnKeyDownDelegate (KeyEvent e);
public delegate void OnKeyUpDelegate (KeyEvent e);

public delegate void OnFocusAcquiredDelegate (Event e);
public delegate void OnFocusLostDelegate (Event e);


public class Event
{
	public bool bIsHandled;
}
