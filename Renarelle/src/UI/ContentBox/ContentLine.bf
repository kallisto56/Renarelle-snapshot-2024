namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class ContentLine
	{
		public ContentBox mContentBox;
		public List<UI.Element> mElements;

		public int mX;
		public int mY;

		public int mWidth;
		public int mHeight;

		public bool bIsEmpty => this.mElements.Count == 0;


		public this ()
		{
			this.mElements = new List<UI.Element>();
		}


		public ~this ()
		{
			delete this.mElements;
		}


		public void Initialize (ContentBox contentBox)
		{
			this.mContentBox = contentBox;
			this.mY = this.mContentBox.mAccumulatedHeight;

			var lineHeight = this.mContentBox.mParent.mContentLineHeight;
			if (lineHeight != -1)
				this.mHeight = lineHeight;

			this.mElements.Clear();
		}


		public bool CanPlace (UI.Element e, int maxWidth, int maxHeight)
		{
			var width = e.GetMarginBoxWidth();
			return (this.mX + width <= maxWidth);
		}


		public void Place (UI.Element e)
		{
			var width = e.GetMarginBoxWidth();
			var height = e.GetMarginBoxHeight();

			e.mLeft = e.mMargin.mLeft + this.mX;
			this.mX += width;

			this.mWidth += width;
			this.mHeight = Math.Max(this.mHeight, height);
			
			var valign = this.mContentBox.mParent.mVerticalAlign;
			var baseline = this.mContentBox.mParent.mContentBaseline;
			if (valign == .Baseline)
			{
				var baselineOffset = (baseline - e.mBaseline);
				e.mTop = e.mMargin.mTop + baselineOffset;
				var bottom = baselineOffset + e.GetMarginBoxHeight();
				if (baselineOffset < 0)
					e.mTop = 0;

				this.mHeight = Math.Max(this.mHeight, bottom);
			}

			this.mElements.Add(e);
		}


		public void TrimWhitespace ()
		{
			var bChanged = false;
			var front = this.mElements.Front;
			if (front.mTextContent != null && front.mTextContent.bIsWhitespace == true)
			{
				this.mWidth -= front.mWidth.mCalculated;
				this.mElements.RemoveAt(0);
				bChanged = true;
			}

			var back = this.mElements.Back;
			if (back.mTextContent != null && back.mTextContent.bIsWhitespace == true)
			{
				this.mWidth -= back.mWidth.mCalculated;
				this.mElements.RemoveAt(this.mElements.Count-1);
				bChanged = true;
			}

			if (bChanged == true)
			{
				for (var n = 0; n < this.mElements.Count; n++)
				{
					var height = this.mElements[n].GetMarginBoxHeight();
					this.mHeight = Math.Max(this.mHeight, height);
				}
			}
		}


		public void Finalize (int x, int y)
		{
			this.mX = x;
			this.mY = y;

			var parent = this.mContentBox.mParent;
			var verticaAlign = parent.mVerticalAlign;
			var anchor = parent.mContentAnchor;
			
			var accumulatedHeight = this.mContentBox.mAccumulatedHeight;

			for (var n = 0; n < this.mElements.Count; n++)
			{
				var e = this.mElements[n];

				var emTop = e.mTop;

				e.mLeft += this.mX;
				e.mTop = this.mY;

				if (verticaAlign == .Top)
				{
					e.mTop = this.mY;
				}
				else if (verticaAlign == .Center)
				{
					e.mTop = this.mY + this.mHeight / 2 - (e.mHeight.mCalculated + e.mMargin.mVertical) / 2;
				}
				else if (verticaAlign == .Bottom)
				{
					e.mTop = this.mY + this.mHeight - (e.mHeight.mCalculated + e.mMargin.mVertical);
				}

				if (anchor == .TopLeft)
				{
					// nothing changes here, it's only here
					// to avoid if-statement checks below.
				}
				else if (anchor == .Top)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) / 2 + e.mLeft;
				}
				else if (anchor == .TopRight)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) + e.mLeft;
				}
				else if (anchor == .Right)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) + e.mLeft;
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight) / 2;
				}
				else if (anchor == .BottomRight)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) + e.mLeft;
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight);
				}
				else if (anchor == .Bottom)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) / 2 + e.mLeft;
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight);
				}
				else if (anchor == .BottomLeft)
				{
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight);
				}
				else if (anchor == .Left)
				{
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight) / 2;
				}
				else if (anchor == .Center)
				{
					e.mLeft = (this.mContentBox.mWidth - this.mWidth) / 2 + e.mLeft;
					e.mTop += (this.mContentBox.mHeight - accumulatedHeight) / 2;
				}

				e.mTop += emTop;
			}
		}
	}
}