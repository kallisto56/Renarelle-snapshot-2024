namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using SDL3.Raw;
using System.Interop;


class Image
{
	public SDL_Surface* mHandle;
	public String mFileName { get; protected set; }
	public int mSizeInBytes => this.mWidth * this.mHandle.pitch;
	public void* CArray() => this.mHandle.pixels;

	public int mWidth => this.mHandle.w;
	public int mHeight => this.mHandle.h;
	public SDL_PixelFormat mPixelFormat => this.mHandle.format;


	public this ()
	{
		this.mFileName = new String();
	}


	public ~this ()
	{
		delete this.mFileName;
		if (this.mHandle != null)
			SDL_DestroySurface(this.mHandle);
	}


	public Response Initialize (Self.Description description)
	{
		this.mFileName.Set(description.mFileName);

		this.mHandle = IMG_Load(this.mFileName.CStr());
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		if (description.mDesiredPixelFormat.HasValue && description.mDesiredPixelFormat.Value != this.mPixelFormat)
			this.Convert(description.mDesiredPixelFormat.Value).Resolve!();

		return .Ok;
	}


	public Response Initialize (Self.BlankDescription description)
	{
		this.mFileName.Set("./blank.png");

		this.mHandle = SDL_CreateSurface(int32(description.mWidth), int32(description.mHeight), description.mDesiredPixelFormat);
		if (this.mHandle == null)
			return new Error()..AppendCStr(SDL_GetError());

		return .Ok;
	}


	public Response Convert (SDL_PixelFormat desiredPixelFormat)
	{
		if (desiredPixelFormat != this.mPixelFormat)
		{
			var handle = SDL_ConvertSurface(this.mHandle, desiredPixelFormat);
			if (handle == null)
				return new Error()..AppendCStr(SDL_GetError());

			SDL_DestroySurface(this.mHandle);
			this.mHandle = handle;
		}

		return .Ok;
	}


	/*public Color GetPixel (int x, int y)
	{
		var idx = ((this.mHeight * y) + x) * this.mHandle.pitch;
		var length = this.mWidth * this.mHeight * this.mHandle.pitch;
		var span = Span<uint8>((.)this.mHandle.pixels, length);

		uint8 r = span[idx + 0];
		uint8 g = span[idx + 1];
		uint8 b = span[idx + 2];
		uint8 a = span[idx + 3];

		Color color = Color(
			float(r) / 255.0F,
			float(g) / 255.0F,
			float(b) / 255.0F,
			float(a) / 255.0F
		);

		return color;
	}


	public void SetPixel (int x, int y, Color color)
	{
		var idx = ((this.mHandle.pitch * y) + this.mWidth * 4);

		uint8* foo = (uint8*)this.mHandle.pixels;

		color.ToUint32(var r, var g, var b, var a);

		foo[idx + 0] = r;
		foo[idx + 1] = g;
		foo[idx + 2] = b;
		foo[idx + 3] = a;
	}*/


	public void FillColor (Color color)
	{
		var value = color.ToUInt32();
		SDL_FillSurfaceRect(this.mHandle, &SDL_Rect(0, 0, this.mWidth, this.mHeight), value);
	}
}