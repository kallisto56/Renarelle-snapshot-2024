namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;

using static Renarelle.UI;


class Widget
{
	public WidgetWindow mWidgetWindow = null;
	public Widget mParent = null;
	public List<Widget> mChildren = null;

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
		this.mChildren = new List<Widget>();
	}


	public ~this ()
	{
		delete this.mChildren;
	}


	public Widget GetDependency ()
	{
		if (this.mPositioning case .RelativeToViewport(?, ?))
			return null;

		if (this.mPositioning case .RelativeToWidget(let dependency))
			return dependency;

		// Case for .Default and .RelativeToParent
		return this.mParent;
	}
}