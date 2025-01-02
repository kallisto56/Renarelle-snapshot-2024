namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public struct DebugDrawSettings
	{
		public bool bDebugDrawMargin = true;
		public bool bDebugDrawBorder = true;
		public bool bDebugDrawPadding = true;
		public bool bDebugDrawContentBox = true;
		public bool bDebugDrawBaseline = false;
		public bool bDebugDrawContentBaseline = false;
		public bool bDebugDrawTextContentBounds = false;
		public bool bDebugDrawContentLine = false;

		public Color mMarginBoxColor = Color.LightYellow(0.5F);
		public Color mMarginBoxBorderColor = Color.Black(0.75F);

		public Color mBorderBoxColor = Color.Black(0.5F);

		public Color mPaddingBoxColor = Color.PaleGreen(0.5F);
		public Color mPaddingBoxBorderColor = Color.Black(0.5F);

		public Color mContentBoxColor = Color.White(0.25F);
		public Color mContentBaselineColor = Color.Blue(1F);
		public Color mBaselineColor = Color.Red(1F);
		public Color mContentLineColor = Color.Red(1F);
		public Color mScrollbarColor = Color.Gray();
		public Color mScrollbarButtonColor = Color.Black(0.5F);
		public Color mScrollbarThumbColor = Color.White(0.35F);
	}
}