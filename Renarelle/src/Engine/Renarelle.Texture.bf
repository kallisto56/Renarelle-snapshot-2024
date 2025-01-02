namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Renarelle
{
	static public Response<Texture> CreateDepthAttachment (int width, int height)
	{
		Texture.Description description = Texture.Description() {
			mFormat = Self.sGraphicsDevice.GetDepthAttachmentFormat().Resolve!(),
		};

		defer { if (@return case .Err) delete texture; }

		Texture texture = new Texture();
		texture.Initialize(description).Resolve!();
		return texture;
	}


	static public Response<Texture> LoadTexture (StringView fileName)
	{
		var image = scope Image();
		image.Initialize(Image.Description() {
			mFileName = fileName,
			mDesiredPixelFormat = .SDL_PIXELFORMAT_RGBA32
		}).Resolve!();

		defer { if (@return case .Err) delete texture; }

		var texture = new Texture();
		texture.Initialize(Texture.Description() {
			mWidth = image.mWidth,
			mHeight = image.mHeight,
			mSampler = Renarelle.sSmoothSampler,
		}).Resolve!();

		texture.Write(image).Resolve!();

		return texture;
	}
}
