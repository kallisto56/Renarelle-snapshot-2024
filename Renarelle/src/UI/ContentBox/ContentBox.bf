namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;

using internal Renarelle.UI.Layout;


extension UI
{
	public class ContentBox
	{
		public UI.Layout mLayout;
		public UI.Element mParent;

		public List<UI.ContentLine> mContentLines;

		public int mWidth;
		public int mHeight;

		public int mMaxWidth;
		public int mMaxHeight;

		public int mAccumulatedWidth;
		public int mAccumulatedHeight;

		// We are copying state of the element to content box so that we could
		// change behaviour in cases, when overflow set to .Auto and we've detected
		// that we need to recalculate layout because content overflowed.
		public Overflow mHorizontalOverflow;
		public Overflow mVerticalOverflow;


		public this ()
		{
			this.mContentLines = new List<UI.ContentLine>();
		}


		public ~this ()
		{
			delete this.mContentLines;
		}


		public void Initialize (UI.Layout layout, UI.Element parent)
		{
			this.mLayout = layout;
			this.mParent = parent;

			this.mAccumulatedWidth = 0;
			this.mAccumulatedHeight = 0;

			var horizontal = (this.mParent.mBorder.mHorizontal + this.mParent.mPadding.mHorizontal);
			var vertical = (this.mParent.mBorder.mVertical + this.mParent.mPadding.mVertical);

			this.mWidth = this.mParent.mWidth.mCalculated - horizontal;
			this.mHeight = this.mParent.mHeight.mCalculated - vertical;

			this.mMaxWidth = this.mParent.mMaxWidth - horizontal;
			this.mMaxHeight = this.mParent.mMaxHeight - vertical;

			this.mHorizontalOverflow = this.mParent.mHorizontalOverflow;
			this.mVerticalOverflow = this.mParent.mVerticalOverflow;

			this.mParent.[Friend]bHorizontalScrollbarEnabled = false;
			this.mParent.[Friend]bVerticalScrollBarEnabled = false;

			if (this.mHorizontalOverflow == .Scroll)
			{
				var offset = (this.mLayout.mScrollBarSettings.mHorizontalScrollBarHeight);
				this.mMaxHeight = this.mMaxHeight - offset;
				this.mParent.[Friend]bHorizontalScrollbarEnabled = true;
			}

			if (this.mVerticalOverflow == .Scroll)
			{
				var offset = (this.mLayout.mScrollBarSettings.mVerticalScrollBarWidth);
				this.mMaxWidth = this.mMaxWidth - offset;
				this.mParent.[Friend]bVerticalScrollBarEnabled = true;
			}

			this.ResetContentLines();
		}


		void ResetContentLines ()
		{
			for (var n = 0; n < this.mContentLines.Count; n++)
				this.mLayout.ReleaseContentLine(this.mContentLines[n]);

			this.mContentLines.Clear();
		}


		public void Place (UI.Element e, out bool bScrollBarTriggered)
		{
			bScrollBarTriggered = false;

			ContentLine contentLine = this.GetOrCreateContentLine();

			if (e.mLineBreak.HasFlag(.Before) && contentLine.bIsEmpty == false)
				contentLine = this.CreateContentLine();

			if (contentLine.CanPlace(e, this.mMaxWidth, this.mMaxHeight) == false && contentLine.bIsEmpty == false)
				contentLine = this.CreateContentLine();

			if (contentLine.bIsEmpty && e.mTextContent?.bIsWhitespace == true)
				return;

			contentLine.Place(e);

			CalculateAccumulatedSize(contentLine);

			if (this.IsHorizontalOverflowHappened() == true)
			{
				bScrollBarTriggered = true;
				return;
			}

			if (this.IsVerticalOverflowHappened() == true)
			{
				bScrollBarTriggered = true;
				return;
			}

			if (e.mLineBreak.HasFlag(.After) && contentLine.mElements.Count > 0)
				this.CreateContentLine();
		}


		bool IsHorizontalOverflowHappened ()
		{
			if (this.mHorizontalOverflow != .Auto)
				return false;

			if (this.mAccumulatedWidth > this.mMaxWidth)
			{
				this.ResetContentLines();
				this.mHorizontalOverflow = .Scroll;
				this.mParent.[Friend]bHorizontalScrollbarEnabled = true;

				var offset = (this.mLayout.mScrollBarSettings.mHorizontalScrollBarHeight);
				this.mMaxHeight = this.mMaxHeight - offset;
				return true;
			}

			return false;
		}


		bool IsVerticalOverflowHappened ()
		{
			if (this.mVerticalOverflow != .Auto)
				return false;

			if (this.mAccumulatedHeight > this.mMaxHeight)
			{
				this.ResetContentLines();
				this.mVerticalOverflow = .Scroll;
				this.mParent.[Friend]bVerticalScrollBarEnabled = true;

				var offset = (this.mLayout.mScrollBarSettings.mVerticalScrollBarWidth);
				this.mMaxWidth = this.mMaxWidth - offset;

				return true;
			}

			return false;
		}


		[Inline]
		void CalculateAccumulatedSize (UI.ContentLine contentLine)
		{
			this.mAccumulatedWidth = Math.Max(this.mAccumulatedWidth, contentLine.mWidth);
			this.mAccumulatedHeight = Math.Max(this.mAccumulatedHeight, contentLine.mY + contentLine.mHeight);
		}


		public void Finalize ()
		{
			var horizontal = (this.mParent.mBorder.mHorizontal + this.mParent.mPadding.mHorizontal);
			var vertical = (this.mParent.mBorder.mVertical + this.mParent.mPadding.mVertical);

			var x = 0;
			var y = 0;

			for (var n = 0; n < this.mContentLines.Count; n++)
			{
				var contentLine = this.mContentLines[n];
				contentLine.Finalize(x, y);
				y += contentLine.mHeight;
			}

			this.mWidth = Math.Max(this.mWidth, this.mAccumulatedWidth);
			this.mHeight = Math.Max(this.mHeight, this.mAccumulatedHeight);

			this.mWidth = Math.Clamp(this.mWidth, this.mParent.mMinWidth, this.mMaxWidth) + horizontal;
			this.mHeight = Math.Clamp(this.mHeight, this.mParent.mMinHeight, this.mMaxHeight) + vertical;

			this.mParent.mWidth.mCalculated = this.mWidth;
			this.mParent.mHeight.mCalculated = this.mHeight;

			this.mParent.[Friend]mContentWidth = this.mAccumulatedWidth;
			this.mParent.[Friend]mContentHeight = this.mAccumulatedHeight;
		}


		ContentLine GetOrCreateContentLine ()
		{
			if (this.mContentLines.Count == 0)
				return this.CreateContentLine();

			return this.mContentLines.Back;
		}


		ContentLine CreateContentLine ()
		{
			if (this.mContentLines.Count > 0)
			{
				var lastContentLine = this.mContentLines.Back;
				lastContentLine.TrimWhitespace();

				CalculateAccumulatedSize(lastContentLine);
			}

			var contentLine = this.mLayout.GetOrCreateContentLine();
			this.mContentLines.Add(contentLine);
			contentLine.Initialize(this);

			return contentLine;
		}
	}
}