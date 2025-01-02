namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


struct Viewport
{
	public int mX;
	public int mY;
	public int mWidth;
	public int mHeight;
	public float mMinDepth;
	public float mMaxDepth;


	public this (int x, int y, int width, int height, float minDepth = 0F, float maxDepth = 1F)
	{
		this.mX = x;
		this.mY = y;

		this.mWidth = width;
		this.mHeight = height;

		this.mMinDepth = minDepth;
		this.mMaxDepth = maxDepth;
	}


	static public implicit operator SDL_GPUViewport (Viewport v)
	{
		return SDL_GPUViewport(v.mX, v.mY, v.mWidth, v.mHeight, v.mMinDepth, v.mMaxDepth);
	}
}