namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class Element
	{
		public Element mParent;
		public List<Element> mChildren;
		public TextContent mTextContent;

		public int mLeft;
		public int mTop;
		[Inline] public int mRight => this.mLeft + this.mWidth.mCalculated;
		[Inline] public int mBottom => this.mTop + this.mHeight.mCalculated;

		public Value mWidth = UI.cMinValue;
		public int mMinWidth = UI.cMinValue;
		public int mMaxWidth = UI.cMaxValue;

		public Value mHeight = UI.cMinValue;
		public int mMinHeight = UI.cMinValue;
		public int mMaxHeight = UI.cMaxValue;

		public Margin mMargin;
		public Border mBorder;
		public Padding mPadding;

		public Color mBackgroundColor = .Transparent;

		/** Offsets position of the element. Only works on root elements. */
		public Anchor mAnchor = .TopLeft;

		/** Adds newline before and/or after current element */
		public LineBreak mLineBreak = .Intact;
		public int mBaseline = 0;

		public VerticalAlign mVerticalAlign = .Top;

		public int mContentBaseline = 0;
		public int mContentLineHeight = -1;
		public Anchor mContentAnchor = .TopLeft;

		public Overflow mHorizontalOverflow = .Visible;
		public Overflow mVerticalOverflow = .Visible;

		public int mVerticalScrollOffset;
		public int mHorizontalScrollOffset;

		public bool bHorizontalScrollbarEnabled { get; protected set; }
		public bool bVerticalScrollBarEnabled { get; protected set; }

		public int mContentWidth { get; protected set; }
		public int mContentHeight { get; protected set; }

		public Positioning mPositioning = .Default;
		public int mZIndex;


		public this ()
		{
			this.mChildren = new List<UI.Element>();
		}


		public ~this ()
		{
			DeleteContainerAndItems!(this.mChildren);
			delete this.mTextContent;
		}


		public void Append (UI.Element child)
		{
			this.mChildren.Add(child);
			child.mParent = this;
		}


		public void Append (StringView textContent, Color color, Font font, int baseline = int.MinValue)
		{
			int x = 0;
			Element word = null;

			int capHeight = int(font.mBaseline);
			var baseline;
			if (baseline == int.MinValue)
			{
				baseline = int(font.mBaseline);
			}

			var n = 0;
			while (n < textContent.Length)
			{
				var char = textContent.GetChar32(n);
				n += char.length;
				char32 lhs = char.c;
				char32? rhs = null;

				if (font.IsWhitespaceOrTabspace(lhs, var advanceWidth) == true)
				{
					x = 0;
					word = this.Append(.. new UI.Element());
					word.mTextContent = new TextContent(font, .Transparent);
					word.mTextContent.mSymbols.Add(Symbol(lhs, .Zero, .Zero, .Zero));
					word.mWidth.mDesired = advanceWidth;
					word.mHeight.mDesired = capHeight;
					word.mTextContent.bIsWhitespace = true;
					word.mBaseline = baseline;

					word = null;

					continue;
				}
				else if (lhs == '\n')
				{
					word = this.Append(.. new UI.Element());
					word.mTextContent = new TextContent(font, .Transparent);
					word.mTextContent.mSymbols.Add(Symbol(lhs, .Zero, .Zero, .Zero));
					word.mTextContent.bIsWhitespace = true;
					word.mLineBreak = .After;

					word = null;
					x = 0;

					continue;
				}

				if (word == null)
				{
					word = new Element();
					word.mTextContent = new UI.TextContent(font, color);
					word.mTextContent.bIsWhitespace = false;
					word.mWidth.mDesired = 0;
					word.mHeight.mDesired = capHeight;
					word.mBaseline = baseline;
					this.Append(word);
				}

				if (n < textContent.Length)
					rhs = textContent.GetChar32(n).c;

				if (font.GetMetrics(lhs, rhs, var metrics) == false)
					continue;

				var size = Vector2(metrics.mPixelCoords[2], metrics.mPixelCoords[3]);

				var position = Vector2(
					x + metrics.mOffsetLeft,
					capHeight - metrics.mOffsetTop
				);

				var uv = Vector4(metrics.mTexCoords);
				Symbol symbol = Symbol(lhs, position, size, uv);

				word.mTextContent.mSymbols.Add(symbol);
				word.mWidth.mDesired += metrics.mAdvanceWidth;

				x += metrics.mAdvanceWidth;
			}
		}


		public UI.Element GetDependency ()
		{
			if (this.mPositioning case .RelativeToViewport(?, ?))
				return null;

			if (this.mPositioning case .RelativeTo(let dependency))
				return dependency;

			// Case for .Default and .RelativeToParent
			return this.mParent;
		}


		[Inline]
		public void GetMarginBox (out int x, out int y, out int width, out int height)
		{
			x = this.mLeft - this.mMargin.mLeft;
			y = this.mTop - this.mMargin.mTop;
			width = this.mWidth.mCalculated + this.mMargin.mHorizontal;
			height = this.mHeight.mCalculated + this.mMargin.mVertical;
		}


		[Inline]
		public void GetBorderBox (out int x, out int y, out int width, out int height)
		{
			x = this.mLeft;
			y = this.mTop;
			width = this.mWidth.mCalculated;
			height = this.mHeight.mCalculated;
		}


		[Inline]
		public void GetPaddingBox (out int x, out int y, out int width, out int height)
		{
			x = this.mLeft + this.mBorder.mLeft;
			y = this.mTop + this.mBorder.mTop;
			width = this.mWidth.mCalculated - this.mBorder.mHorizontal;
			height = this.mHeight.mCalculated - this.mBorder.mVertical;
		}


		[Inline]
		public void GetContentBox (out int x, out int y, out int width, out int height)
		{
			x = this.mLeft + this.mBorder.mLeft + this.mPadding.mLeft;
			y = this.mTop + this.mBorder.mTop + this.mPadding.mTop;
			width = this.mWidth.mCalculated - this.mBorder.mHorizontal - this.mPadding.mHorizontal;
			height = this.mHeight.mCalculated - this.mBorder.mVertical - this.mPadding.mVertical;
		}


		[Inline] public int GetMarginBoxWidth() => this.mMargin.mHorizontal + this.mWidth.mCalculated;
		[Inline] public int GetMarginBoxHeight() => this.mMargin.mVertical + this.mHeight.mCalculated;
	}
}