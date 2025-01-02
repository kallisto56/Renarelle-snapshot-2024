namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension SDL_GPUViewport
{
	public this (int x, int y, int width, int height, float minDepth, float maxDepth)
	{
		this.x = x;
		this.y = y;
		this.w = width;
		this.h = height;
		this.min_depth = minDepth;
		this.max_depth = maxDepth;
	}
}