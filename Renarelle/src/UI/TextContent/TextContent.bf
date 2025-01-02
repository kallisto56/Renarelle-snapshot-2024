namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class TextContent
	{
		public List<Symbol> mSymbols;
		public Font mFont;
		public Color mColor;
		public bool bIsWhitespace;


		public this (Font font, Color color)
		{
			this.mSymbols = new List<UI.Symbol>();
			this.mFont = font;
			this.mColor = color;
		}


		public ~this ()
		{
			delete this.mSymbols;
		}
	}
}