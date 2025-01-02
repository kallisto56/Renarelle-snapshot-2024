namespace Renarelle.Editor;


using System;
using System.IO;
using System.Collections;
using System.Diagnostics;
using System.Math;

using SDL3.Raw;


class Program
{
	static void Main ()
	{
		Application application = scope Application();

		Renarelle.Description description = Renarelle.Description()
		{
			mOnInitialize = scope => application.Initialize,
			mOnUpdate = scope => application.OnUpdate,
			mOnShutdown = scope => application.OnShutdown,

			mGraphicsBackend = .Direct3D11,
			bEnableGraphicsDebugging = true,
		};

		if (Renarelle.Run(description) case .Err(Error error))
			Debug.Report(error, bIsCritical: true);
	}
}

class VertexLayout
{
	public Element[] mElements;
	public int mSizeInBytes;


	public this (int sizeInBytes, params Element[] elements)
	{
		this.mElements = new Element[elements.Count];
		this.mSizeInBytes = sizeInBytes;

		for (var n = 0; n < this.mElements.Count; n++)
		{
			var e = elements[n];
			this.mElements[n] = Element(e.mType, e.bIsNormalized) { mIndex = n };
		}
	}


	public ~this ()
	{
		delete this.mElements;
	}


	public struct Element
	{
		public int mIndex;
		public VertexType mType;
		public bool bIsNormalized = true;


		public this (VertexType type, bool bIsNormalized = true)
		{
			this.mIndex = -1;
			this.mType = type;
			this.bIsNormalized = bIsNormalized;
		}
	}


	public enum VertexType
	{
		case Float;
		case Float2;
		case Float3;
		case Float4;

		public int GetSizeInBytes ()
		{
			if (this case .Float) return sizeof(float);
			if (this case .Float2) return sizeof(float) * 2;
			if (this case .Float3) return sizeof(float) * 3;
			if (this case .Float4) return sizeof(float) * 4;

			Runtime.FatalError();
		}
	}
}


/*class Element
{
	public int mWidth = 0;
	public int mMinWidth = 0;
	public int mMaxWidth = int.MaxValue;
	
	public int mHeight = 0;
	public int mMinHeight = 0;
	public int mMaxHeight = int.MaxValue;

	public UI.Margin mMargin;
	public UI.Border mBorder;
	public UI.Padding mPadding;

	[Inline] public int GetMarginBoxWidth() => this.mMargin.mHorizontal + this.mBorder.mHorizontal + this.mPadding.mHorizontal + this.mWidth;
	[Inline] public int GetMarginBoxHeight() => this.mMargin.mVertical + this.mBorder.mVertical + this.mPadding.mVertical + this.mHeight;

	[Inline] public int GetBorderBoxWidth() => this.mBorder.mHorizontal + this.mPadding.mHorizontal + this.mWidth;
	[Inline] public int GetBorderBoxHeight() => this.mBorder.mVertical + this.mPadding.mVertical + this.mHeight;

	[Inline] public int GetPaddingBoxWidth() => this.mPadding.mHorizontal + this.mWidth;
	[Inline] public int GetPaddingBoxHeight() => this.mPadding.mVertical + this.mHeight;
}


struct ContentBox
{
	public int mWidth;
	public int mHeight;
	public int mMaxWidth;
	public int mMaxHeight;


	public this (Element e)
	{
		this.mWidth = 0;
		this.mHeight = 0;

		this.mMaxWidth = e.mMaxWidth - (e.mBorder.mHorizontal - e.mPadding.mHorizontal);
		this.mMaxHeight = e.mMaxHeight - (e.mBorder.mHorizontal - e.mPadding.mHorizontal);
	}
}*/