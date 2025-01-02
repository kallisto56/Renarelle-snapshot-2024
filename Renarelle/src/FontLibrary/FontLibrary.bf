namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;
using FreeType;


class FontLibrary
{
	static public FontLibrary sMainThreadInstance;

	public FT_Library mHandle;


	public this (bool bIsMainThreadInstance = false)
	{
		if (bIsMainThreadInstance)
			FontLibrary.sMainThreadInstance = this;
	}


	public Response Initialize ()
	{
		var response = FT_Init_FreeType(out this.mHandle);
		if (response != .FT_Err_Ok)
			return new Error()..AppendF("FT_Init_FreeType responded with {}.", response);

		return .Ok;
	}


	public ~this ()
	{
		if (this.mHandle != null)
		{
			var response = FT_Done_FreeType(this.mHandle);
			if (response != .FT_Err_Ok)
				Debug.Warning!(scope $"FT_Done_FreeType responded with {response}.");
		}
	}
}