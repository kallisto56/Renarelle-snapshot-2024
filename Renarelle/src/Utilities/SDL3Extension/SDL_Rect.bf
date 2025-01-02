namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension SDL_Rect
{
	public this (int x, int y, int width, int height)
	{
		this.x = int32(x);
		this.y = int32(y);
		this.w = int32(width);
		this.h = int32(height);
	}


	public this (float x, float y, float width, float height)
	{
		this.x = int32(x);
		this.y = int32(y);
		this.w = int32(width);
		this.h = int32(height);
	}
}