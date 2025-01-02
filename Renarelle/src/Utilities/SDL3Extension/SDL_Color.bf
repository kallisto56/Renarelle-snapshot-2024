namespace SDL3.Raw;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension SDL_Color
{
	public this (int r, int g, int b, int a = 255)
	{
		this.r = uint8(r);
		this.g = uint8(g);
		this.b = uint8(b);
		this.a = uint8(a);
	}


	public this (float r, float g, float b, float a = 1.0F)
	{
		this.r = uint8(r * 255);
		this.g = uint8(g * 255);
		this.b = uint8(b * 255);
		this.a = uint8(a * 255);
	}


	public void GetValues (out uint8 r, out uint8 g, out uint8 b, out uint8 a)
	{
		r = this.r;
		g = this.g;
		b = this.b;
		a = this.a;
	}


	static public implicit operator Color (SDL_Color color)
	{
		return Color(
			float(color.r) / 255,
			float(color.g) / 255,
			float(color.b) / 255,
			float(color.a) / 255
		);
	}


	static public implicit operator SDL_Color (Color color)
	{
		return SDL_Color(
			uint8(color.mR * 255),
			uint8(color.mG * 255),
			uint8(color.mB * 255),
			uint8(color.mA * 255)
		);
	}
}