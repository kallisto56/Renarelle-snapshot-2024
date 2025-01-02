namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


struct Scissor
{
	public int mLeft;
	public int mTop;
	public int mWidth;
	public int mHeight;

	[Inline] public bool bIsValid => this.mWidth > 0 && this.mHeight > 0;


	public this (int left, int top, int width, int height)
	{
		this.mLeft = left;
		this.mTop = top;
		this.mWidth = width;
		this.mHeight = height;
	}


	public this (float left, float top, float width, float height)
	{
		this.mLeft = int(left);
		this.mTop = int(top);
		this.mWidth = int(width);
		this.mHeight = int(height);
	}


	[Commutable]
	static public bool operator == (Scissor lhs, Scissor rhs)
	{
		return lhs.mLeft == rhs.mLeft
			&& lhs.mTop == rhs.mTop
			&& lhs.mWidth == rhs.mWidth
			&& lhs.mHeight == rhs.mHeight;
	}


	static public implicit operator SDL_Rect (Scissor scissors)
	{
		return SDL_Rect(scissors.mLeft, scissors.mTop, scissors.mWidth, scissors.mHeight);
	}


	static public Scissor Clip (Scissor parent, Scissor child)
	{
		int left = Math.Max(parent.mLeft, child.mLeft);
		int top = Math.Max(parent.mTop, child.mTop);
		int right = Math.Min(parent.mLeft + parent.mWidth, child.mLeft + child.mWidth);
		int bottom = Math.Min(parent.mTop + parent.mHeight, child.mTop + child.mHeight);

		// Calculate the width and height of the new Scissor
		int width = Math.Max(0, right - left);
		int height = Math.Max(0, bottom - top);

		return Scissor(left, top, width, height);
	}
}