namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public struct Symbol
	{
		public char32 mUnicode;
		public Vector2 mPosition;
		public Vector2 mSize;
		public Vector4 mUV;


		public this (char32 unicode, Vector2 position, Vector2 size, Vector4 uv)
		{
			this.mUnicode = unicode;
			this.mPosition = position;
			this.mSize = size;
			this.mUV = uv;
		}
	}
}