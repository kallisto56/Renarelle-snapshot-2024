namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


public class FontFace
{
	public FT_Face mHandle;

	public String mFileName;
	public String mFamilyName;
	public String mStyleName;

	public float mPointSize;
	public float mLineHeight;
	public float mAscent;
	public float mCapHeight;
	public float mMeanline;
	public float mDescent;


	public Response Initialize (StringView fileName, int faceIdx, float pointSize)
	{
		this.mFileName.Set(fileName);

		var response = FT_New_Face(FontLibrary.sMainThreadInstance.mHandle, this.mFileName.CStr(), .(faceIdx), out this.mHandle);
		if (response != .FT_Err_Ok)
			return new Error()..AppendF("FT_New_Face responded with {}.", response);

		this.mFamilyName.Set(StringView(this.mHandle.family_name));
		this.mStyleName.Set(StringView(this.mHandle.style_name));

		this.SetSize(pointSize);

		return .Ok;
	}


	public void SetSize (float pointSize)
	{
		if (pointSize == this.mPointSize)
			return;

		this.mPointSize = pointSize;

		FT_Set_Char_Size(this.mHandle, 0, .(this.mPointSize * FT_FIXED_POINT_SCALE), 0, 72);

		this.mLineHeight = this.mHandle.size.metrics.height / FT_FIXED_POINT_SCALE;
		this.mAscent = this.mHandle.size.metrics.ascender / FT_FIXED_POINT_SCALE;
		this.mDescent = this.mHandle.size.metrics.descender / FT_FIXED_POINT_SCALE;
		this.mCapHeight = this.CalculateHeight('H') / FT_FIXED_POINT_SCALE;
		this.mMeanline = this.CalculateHeight('x') / FT_FIXED_POINT_SCALE;
	}


	FT_Pos CalculateHeight (char32 char)
	{
		if (FT_Load_Char(this.mHandle, uint32(char), .FT_LOAD_DEFAULT) != .FT_Err_Ok)
			Debug.SafeBreak();

		return this.mHandle.glyph.metrics.height;
	}


	public this ()
	{
		this.mFileName = new String();
		this.mFamilyName = new String();
		this.mStyleName = new String();
	}


	public ~this ()
	{
		if (this.mHandle != null)
		{
			var response = FT_Done_Face(this.mHandle);
			if (response != .FT_Err_Ok)
				Debug.Warning!(scope $"FT_Done_Face responded with {response}.");
		}

		delete this.mFileName;
		delete this.mFamilyName;
		delete this.mStyleName;
	}
}