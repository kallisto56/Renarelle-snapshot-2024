namespace Renarelle.Editor;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;
using System.Interop;
using SDL3.Raw;


class Application
{
	public Window mPrimaryWindow;

	public Font mFont48;
	public Font mFont13;
	public Texture mButtonTexture;

	public UI.Layout mUILayout;
	//public UI.IRenderer mUIRenderer;
	public UI.Tree mMainUITree;

	//public UI.Tree mTree = new UI.Tree() ~ delete _;

	public Color[?] mColors = Color[?] (
		//SDL_Color(0, 18, 25, 255),
		SDL_Color(0, 95, 115, 255),
		SDL_Color(10, 147, 150, 255),
		SDL_Color(148, 210, 189, 255),
		SDL_Color(233, 216, 166, 255),
		SDL_Color(238, 155, 0, 255),
		SDL_Color(202, 103, 2, 255),
		SDL_Color(187, 62, 3, 255),
		SDL_Color(174, 32, 18, 255),
		SDL_Color(155, 34, 38, 255),
	);

	//UI.Element mFirstParagraph;


	public Response Initialize ()
	{
		this.mPrimaryWindow = new Window();
		this.mPrimaryWindow.Initialize().Resolve!();
		this.mPrimaryWindow.mOnRender.Add(new => this.OnRender);
		this.mPrimaryWindow.SetTitle("Primary");

		this.mFont48 = Font.LoadFont("./dist/fonts/Roboto-Regular.ttf", 48).Resolve!();
		this.mFont13 = Font.LoadFont("./dist/fonts/Roboto-Regular.ttf", 13).Resolve!();

		//this.mUIRenderer = new DefaultUIRenderer(this.mPrimaryWindow.mRenderer2D);
		this.mUILayout = new UI.Layout(this.mPrimaryWindow.mRenderer2D);
		this.mMainUITree = new UI.Tree(this.mUILayout);
		this.mMainUITree.mRootElement = new UI.Element()
		{
			mWidth = 512,
			mHeight = 512,
			mBackgroundColor = .Black(0.25F),
			mMargin = 5,
			mBorder = 2,
			mPadding = 10,
		};

		this.mMainUITree.mLeft = 50;

		return .Ok;
	}


	public Response OnUpdate ()
	{
		if (this.mPrimaryWindow.bIsPendingClosure == true)
			Renarelle.bIsPendingClosure = true;

		this.mMainUITree.OnUpdate();
		
		return .Ok;
	}


	public Response OnRender (Window window, Renderer2D renderer)
	{
		//this.mMainUITree.OnRender(window, renderer);
		//this.mMainUITree.mLeft = 0;
		var root = scope UI.Element()
		{
			mWidth = Input.MousePosition.mX,
			mMaxWidth = int(Input.MousePosition.mX),
			mHeight = Input.MousePosition.mY,
			mMaxHeight = int(Input.MousePosition.mY),

			mMargin = 20,
			mBorder = 2,
			mPadding = 10,
			mBackgroundColor = .Black(0.25F),
			mContentAnchor = .BottomRight,

			mHorizontalOverflow = .Visible,
			mVerticalOverflow = .Visible,
			mContentLineHeight = int(this.mFont13.mLineHeight),
		};

		for (var n = 0; n < this.mColors.Count; n++)
		{
			root.Append(new UI.Element() {
				mWidth = 32,
				mHeight = 32,
				mBackgroundColor = this.mColors[n],
			});
		}

		var target0 = root.mChildren[0];
		var target1 = root.Append(.. new UI.Element() {
			mMaxWidth = 92,
			mHeight = 56,
			mPadding = 10,
			mBorder = 2,
			mBackgroundColor = .Black(0.5F),
			mPositioning = .RelativeTo(target0),
			mAnchor = .BottomRight,
		});

		var target2 = root.Append(.. new UI.Element() {
			mWidth = 56,
			mHeight = 56,
			mBackgroundColor = .Red(0.5F),
			mPositioning = .RelativeTo(target1),
			mAnchor = .BottomRight,
		});

		root.Append(new UI.Element() {
			mWidth = 32,
			mHeight = 32,
			mBackgroundColor = .Green(0.5F),
			mPositioning = .RelativeTo(target2),
			mAnchor = .TopRight,
		});
		

		for (var n = 0; n < this.mColors.Count; n++)
		{
			target1.Append(new UI.Element() {
				mWidth = 32,
				mHeight = 32,
				mBackgroundColor = this.mColors[n],
			});
		}

		root.mChildren[5].Append(new UI.Element() {
			mWidth = 32,
			mHeight = 32,
			mBackgroundColor = .Orange(0.5F),
			mPositioning = .RelativeToParent(50, 0),
			mAnchor = .BottomLeft,
		});

		root.mChildren[4].Append(new UI.Element() {
			mWidth = 32,
			mHeight = 32,
			mBackgroundColor = .Purple(0.5F),
			mPositioning = .RelativeToViewport(100, 100),
			mAnchor = .BottomLeft,
		});


		UI.Layout layout = scope UI.Layout(renderer);
		layout.Compute(root);
		layout.DebugDraw(root);

		return .Ok;
	}


	public Response OnShutdown ()
	{
		this.mButtonTexture?.ReleaseRef();
		this.mPrimaryWindow?.ReleaseRef();
		this.mFont48?.ReleaseRef();
		this.mFont13?.ReleaseRef();

		delete this.mMainUITree;
		delete this.mUILayout;
		//delete this.mUIRenderer;

		return .Ok;
	}
}