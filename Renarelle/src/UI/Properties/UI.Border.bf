namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;


extension UI
{
	public struct Border
	{
		public int[4] mSides;
		public int[4] mCorners;


		public this (int left, int top, int right, int bottom, int topLeft = 0, int topRight = 0, int bottomRight = 0, int bottomLeft = 0)
		{
			this.mSides = int[4](left, top, right, bottom);
			this.mCorners = int[4](topLeft, topRight, bottomRight, bottomLeft);
		}


		public this (int sides, int cornerRadius = 0)
		{
			this.mSides = int[4](sides, sides, sides, sides);
			this.mCorners = int[4](cornerRadius, cornerRadius, cornerRadius, cornerRadius);
		}


		public int mHorizontal => this.mLeft + this.mRight;
		public int mVertical => this.mTop + this.mBottom;
		public bool bIsEmpty =>
			(this.mLeft == 0 && this.mTop == 0 && this.mRight == 0 && this.mBottom == 0) &&
			(this.mTopLeft == 0 && this.mTopRight == 0 && this.mBottomRight == 0 && this.mBottomLeft == 0)
			;


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


		public int mTopLeft
		{
			[Inline] get { return this.mCorners[0]; }
			[Inline] set mut { this.mCorners[0] = value; }
		}


		public int mTopRight
		{
			[Inline] get { return this.mCorners[1]; }
			[Inline] set mut { this.mCorners[1] = value; }
		}


		public int mBottomRight
		{
			[Inline] get { return this.mCorners[2]; }
			[Inline] set mut { this.mCorners[2] = value; }
		}


		public int mBottomLeft
		{
			[Inline] get { return this.mCorners[3]; }
			[Inline] set mut { this.mCorners[3] = value; }
		}


		static public implicit operator Border (int value)
		{
			return Border(value);
		}
	}
}