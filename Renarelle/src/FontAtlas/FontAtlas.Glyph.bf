namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;

using FreeType;


extension FontAtlas
{
	public struct Glyph : IDisposable
	{
		public char32 mUnicode;
		public FT_UInt mIndex;

		public int mAdvanceWidth;
		public int mAdvanceHeight;

		public int mOffestLeft;
		public int mOffsetTop;

		public int[4] mPixelCoords;
		public float[4] mTexCoords;

		public FT_Glyph_Metrics mMetrics;

		public Dictionary<char32, Kerning> mKernings;


		public void Dispose ()
		{
			delete this.mKernings;
		}
	}
}