namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


extension UI
{
	public struct Margin
	{
		public int[4] mSides;


		public this (int left, int top, int right, int bottom)
		{
			this.mSides = int[4](left, top, right, bottom);
		}


		public this (int all)
		{
			this.mSides = int[4](all, all, all, all);
		}


		public int mHorizontal => this.mLeft + this.mRight;
		public int mVertical => this.mTop + this.mBottom;
		public bool bIsEmpty => this.mLeft == 0 && this.mTop == 0 && this.mRight == 0 && this.mBottom == 0;


		public int mLeft
		{
			[Inline] get { return this.mSides[0]; }
			[Inline] set mut { this.mSides[0] = value; }
		}


		public int mTop
		{
			[Inline] get { return this.mSides[1]; }
			[Inline] set mut { this.mSides[1] = value; }
		}


		public int mRight
		{
			[Inline] get { return this.mSides[2]; }
			[Inline] set mut { this.mSides[2] = value; }
		}


		public int mBottom
		{
			[Inline] get { return this.mSides[3]; }
			[Inline] set mut { this.mSides[3] = value; }
		}


		static public implicit operator Margin (int value)
		{
			return Margin(value);
		}
	}
}