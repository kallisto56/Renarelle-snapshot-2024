namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension SDL_FColor
{
	public this (int r, int g, int b, int a = 255)
	{
		this.r = float(r) / 255F;
		this.g = float(g) / 255F;
		this.b = float(b) / 255F;
		this.a = float(a) / 255F;
	}


	public this (float r, float g, float b, float a = 1.0F)
	{
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
	}


	static public implicit operator Color (SDL_FColor color)
	{
		return Color(color.r, color.g, color.b, color.a);
	}


	static public implicit operator SDL_FColor (Color color)
	{
		return SDL_FColor(color.mR, color.mG, color.mB, color.mA);
	}
}