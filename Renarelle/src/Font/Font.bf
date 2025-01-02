namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;
using FreeType;


class Font : FontAtlas
{
	public Texture mTexture;


	public Response Initialize (FontAtlas.Image image, Sampler sampler)
	{
		Image.ConvertToARGB8888(image);

		this.mTexture = new Texture();
		this.mTexture.Initialize(Texture.Description() {
			mWidth = image.mWidth,
			mHeight = image.mHeight,
			mSampler = sampler,
		}).Resolve!();

		this.mTexture.Write(image.CArray(), image.SizeInBytes()).Resolve!();

		return .Ok;
	}


	public ~this ()
	{
		this.mTexture.ReleaseRef();
	}


	static public Response<Font> LoadFont (StringView fileName, float pointSize, Sampler sampler = null, FT_Render_Mode renderMode = .FT_RENDER_MODE_NORMAL)
	{
		var sampler;
		if (sampler == null)
			sampler = Renarelle.sSmoothSampler;

		FontAtlas.Image image = scope FontAtlas.Image(768, 768, 1);

		FontFace fontFace = scope FontFace();
		fontFace.Initialize(fileName, 0, pointSize).Resolve!();

		Font font = new Font();

		FontAtlas.Description atlasDescription = FontAtlas.Description()
		{
			mFontFace = fontFace,
			mPointSize = pointSize,
			mCharacterSets = scope StringView[] (CharacterSets.EN, CharacterSets.Numbers, CharacterSets.Symbols),
			mRenderMode = renderMode,
		};

		if (font.Initialize(atlasDescription, image) case .Err(Error error))
		{
			delete font;
			return new Error(error);
		}

		if (font.Initialize(image, sampler) case .Err(Error error))
		{
			delete font;
			return new Error(error);
		}

		return font;
	}
}