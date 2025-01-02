namespace Renarelle;


using System;
using System.Collections;
using System.Math;


extension UI
{
	public enum Positioning
	{
		case Default;
		case RelativeToParent (int x, int y);
		case RelativeToViewport (int x, int y);
		case RelativeTo (UI.Element e);
		case RelativeToWidget (Widget e);
	}
}