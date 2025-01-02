namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class Layout
	{
		public DebugDrawSettings mDebugDrawSettings = DebugDrawSettings();
		public ScrollBarSettings mScrollBarSettings = ScrollBarSettings();
		public Renderer2D mRenderer;

		public List<Element> mFloatingElements;


		public this (Renderer2D renderer)
		{
			this.mRenderer = renderer;
			this.mFloatingElements = new List<UI.Element>();
		}


		public ~this ()
		{
			delete this.mFloatingElements;
		}


		public void Compute (UI.Element e, bool bFirstInvocation = true, bool bAddFloatingElements = true)
		{
			e.mLeft = 0;
			e.mTop = 0;

			e.mWidth.mCalculated = Math.Clamp(e.mWidth.mDesired, e.mMinWidth, e.mMaxWidth);
			e.mHeight.mCalculated = Math.Clamp(e.mHeight.mDesired, e.mMinHeight, e.mMaxHeight);

			if (e.mChildren.Count > 0)
			{
				// Reseting scrollbar trigger
				e.[Friend]bVerticalScrollBarEnabled = false;
				e.[Friend]bHorizontalScrollbarEnabled = false;

				var contentBox = this.GetOrCreateContentBox(e);
				defer { this.ReleaseContentBox(contentBox); }

				for (var n = 0; n < e.mChildren.Count; n++)
				{
					var child = e.mChildren[n];
					if (child.mPositioning != .Default)
					{
						if (bAddFloatingElements == true)
							this.mFloatingElements.Add(child);

						continue;
					}

					this.Compute(child, bFirstInvocation: false, bAddFloatingElements);

					contentBox.Place(child, var bScrollBarTriggered);

					// Case, when placing element caused for scrollbar to appear
					if (bScrollBarTriggered == true)
						n = -1;
				}

				contentBox.Finalize();
			}

			this.AnchorElement(e);

			// Code below sorts floating elements in such a way, that dependants go after dependencies.
			// After that, we iterate over a sorted list and compute layout for each floating element.
			if (bFirstInvocation == false || this.mFloatingElements.Count == 0)
				return;

			var elements = PerformTopologicalSort(this.mFloatingElements);
			defer { delete elements; }

			for (var n = 0; n < elements.Count; n++)
				this.Compute(elements[n], false, false);

			this.mFloatingElements.Clear();
		}


		static List<UI.Element> PerformTopologicalSort (List<UI.Element> elements)
		{
			// Collect dependencies
		    var dependencyNodes = new List<DependencyNode>();
			defer { DeleteContainerAndItems!(dependencyNodes); }

			for (var n = 0; n < elements.Count; n++)
				dependencyNodes.Add(new DependencyNode(elements[n]));

			var inDegree = scope Dictionary<UI.Element, int>();
			var adjList = new Dictionary<UI.Element, List<UI.Element>>();
			defer { DeleteDictionaryAndValues!(adjList); }

			var result = new List<UI.Element>();
			var queue = scope Queue<UI.Element>();


			// Initialize in-degree and adjacency list
			for (var node in dependencyNodes)
			{
			    if (!inDegree.ContainsKey(node.mDependant))
			        inDegree.Add(node.mDependant, 0);

			    if (!adjList.ContainsKey(node.mDependant))
					adjList.Add(node.mDependant, new List<UI.Element>());

			    for (var dependency in node.mDependencies)
			    {
			        if (!inDegree.ContainsKey(dependency))
			            inDegree.Add(dependency, 0);

			        if (!adjList.ContainsKey(dependency))
			            adjList.Add(dependency, new List<UI.Element>());

			        adjList[dependency].Add(node.mDependant);
			        inDegree[node.mDependant]++;
			    }
			}

		    // Enqueue elements with zero in-degree
		    for (var kvp in inDegree)
		    {
		        if (kvp.value == 0)
		        {
		            queue.Add(kvp.key);
		        }
		    }

		    // Process the queue
		    while (queue.Count > 0)
		    {
		        var current = queue.PopFront();
		        result.Add(current);
		
		        if (adjList.ContainsKey(current))
		        {
		            for (var dependent in adjList[current])
		            {
		                inDegree[dependent]--;
		                if (inDegree[dependent] == 0)
		                    queue.Add(dependent);
		            }
		        }
		    }
		
		    // Check for cycles
		    if (result.Count != inDegree.Count)
		        Runtime.FatalError("The graph has at least one cycle.");
		
		    return result;
		}


		void ComputeFloatingElement (UI.Element e)
		{
			e.mLeft = 0;
			e.mTop = 0;

			e.mWidth.mCalculated = Math.Clamp(e.mWidth.mDesired, e.mMinWidth, e.mMaxWidth);
			e.mHeight.mCalculated = Math.Clamp(e.mHeight.mDesired, e.mMinHeight, e.mMaxHeight);

			if (e.mChildren.Count > 0)
			{
				// Reseting scrollbar trigger
				e.[Friend]bVerticalScrollBarEnabled = false;
				e.[Friend]bHorizontalScrollbarEnabled = false;

				var contentBox = this.GetOrCreateContentBox(e);
				defer { this.ReleaseContentBox(contentBox); }

				for (var n = 0; n < e.mChildren.Count; n++)
				{
					var child = e.mChildren[n];
					if (child.mPositioning != .Default)
						continue;

					this.Compute(child, false);

					contentBox.Place(child, var bScrollBarTriggered);

					// Case, when placing element caused for scrollbar to appear
					if (bScrollBarTriggered == true)
						n = -1;
				}

				contentBox.Finalize();
			}

			this.AnchorElement(e);
		}


		[Inline]
		void AnchorElement (UI.Element e)
		{
			if (e.mAnchor == .TopLeft)
			{
				e.mLeft = e.mMargin.mLeft;
				e.mTop = e.mMargin.mTop;
			}
			else if (e.mAnchor == .Top)
			{
				e.mLeft = -e.mWidth.mCalculated / 2;
				e.mTop = e.mMargin.mTop;
			}
			else if (e.mAnchor == .TopRight)
			{
				e.mLeft = -e.mWidth.mCalculated - e.mMargin.mLeft;
				e.mTop = e.mMargin.mTop;
			}
			else if (e.mAnchor == .Right)
			{
				e.mLeft = -e.mWidth.mCalculated - e.mMargin.mLeft;
				e.mTop = -e.mHeight.mCalculated / 2;
			}
			else if (e.mAnchor == .BottomRight)
			{
				e.mLeft = -e.mWidth.mCalculated - e.mMargin.mLeft;
				e.mTop = -e.mHeight.mCalculated - e.mMargin.mTop;
			}
			else if (e.mAnchor == .Bottom)
			{
				e.mLeft = -e.mWidth.mCalculated / 2;
				e.mTop = -e.mHeight.mCalculated - e.mMargin.mTop;
			}
			else if (e.mAnchor == .BottomLeft)
			{
				e.mLeft = e.mMargin.mLeft;
				e.mTop = -e.mHeight.mCalculated - e.mMargin.mTop;
			}
			else if (e.mAnchor == .Left)
			{
				e.mLeft = e.mMargin.mLeft;
				e.mTop = -e.mHeight.mCalculated / 2;
			}
			else if (e.mAnchor == .Center)
			{
				e.mLeft = -e.mWidth.mCalculated / 2;
				e.mTop = -e.mHeight.mCalculated / 2;
			}

			// Positioning
			if (e.mPositioning case .Default)
			{
				// It's here just to skip other options
			}
			else if (e.mPositioning case .RelativeTo(let target))
			{
				e.mLeft += target.mLeft;
				e.mTop += target.mTop;
			}
			else if (e.mPositioning case .RelativeToParent(let x, let y))
			{
				e.mLeft += x;
				e.mTop += y;
			}
			else if (e.mPositioning case .RelativeToViewport(let x, let y))
			{
				e.mLeft += x;
				e.mTop += y;
			}
		}


		internal ContentBox GetOrCreateContentBox (UI.Element e)
		{
			var contentBox = new UI.ContentBox();
			contentBox.Initialize(this, e);
			return contentBox;
		}


		internal ContentLine GetOrCreateContentLine ()
		{
			return new UI.ContentLine();
		}


		internal void ReleaseContentBox (ContentBox contentBox)
		{
			for (var n = 0; n < contentBox.mContentLines.Count; n++)
				delete contentBox.mContentLines[n];

			delete contentBox;
		}


		internal void ReleaseContentLine (ContentLine contentLine)
		{
			delete contentLine;
		}


		public void Draw ()
		{

		}


		public void DebugDrawAnchor (int x, int y, UI.Anchor anchor)
		{
			int width = 15;
			int height = 15;
			int offsetX = 15;
			int offsetY = 15;

			if (anchor == .TopLeft)
			{
			}
			else if (anchor == .Top)
			{
				
			}
			else if (anchor == .TopRight)
			{
				
			}
			else if (anchor == .Right)
			{
				
			}
			else if (anchor == .BottomRight)
			{
				
			}
			else if (anchor == .Bottom)
			{
				
			}
			else if (anchor == .BottomLeft)
			{
				
			}
			else if (anchor == .Left)
			{

			}
			else if (anchor == .Center)
			{
				this.mRenderer.DrawLine(x-offsetX, y, x+width, y, 1, Color.Red());
				this.mRenderer.DrawLine(x, y-offsetY, x, y+height, 1, Color.Red());
			}

			this.mRenderer.DrawLine(x-offsetX, y, x+width, y, 1, Color.Red());
			this.mRenderer.DrawLine(x, y-offsetY, x, y+height, 1, Color.Red());

			//this.mRenderer.DrawLine(x - offsetX, y - offsetY, x + width + offsetX, y + offsetY, 1, Color.Red());
		}


		public void DebugDraw (UI.Element e, int xOffset = 0, int yOffset = 0, int depth = int.MaxValue)
		{
			this.DebugDrawMarginBox(e, xOffset, yOffset);
			this.DebugDrawBorderBox(e, xOffset, yOffset);
			this.DebugDrawPaddingBox(e, xOffset, yOffset);
			this.DebugDrawContentBox(e, xOffset, yOffset);
			this.DebugDrawBaseLine(e, xOffset, yOffset);
			this.DebugDrawTextContent(e, xOffset, yOffset);
			this.DebugDrawScrollBars(e, xOffset, yOffset);

			if (e.mChildren.Count > 0 && depth - 1 > 0)
			{
				e.GetContentBox(var x, var y, var width, var height);

				x += xOffset;
				y += yOffset;


				/*var scissor = Scissor(x, y, width, height);

				if (e.mVerticalOverflow == .Hidden)
				{

				}
				else if (e.mVerticalOverflow == .Visible)
				{
					scissor.mHeight = e.mHeight.mCalculated - e.mBorder.mVertical - e.mPadding.mVertical;// (e.mContentHeight + e.mMargin.mVertical + e.mBorder.mVertical + e.mPadding.mVertical);
				}

				if (e.mHorizontalOverflow == .Hidden)
				{

				}
				else if (e.mHorizontalOverflow == .Visible)
				{
					scissor.mWidth = (e.mContentWidth + e.mMargin.mHorizontal + e.mBorder.mHorizontal + e.mPadding.mHorizontal);
				}

				if (e.bHorizontalScrollbarEnabled == true)
				{
					scissor.mHeight -= this.mScrollBarSettings.mHorizontalScrollBarHeight;
				}

				if (e.bVerticalScrollBarEnabled == true)
				{
					scissor.mWidth -= this.mScrollBarSettings.mVerticalScrollBarWidth;
				}

				if (scissor.bIsValid == true)
				{
					var disposable = this.mRenderer.Push(scissor);
					defer :: disposable.Dispose();
				}*/

				var xOffset;
				var yOffset;

				xOffset += e.mLeft + e.mBorder.mLeft + e.mPadding.mLeft;
				yOffset += e.mTop + e.mBorder.mTop + e.mPadding.mTop;

				for (var n = 0; n < e.mChildren.Count; n++)
				{
					var child = e.mChildren[n];
					if (child.mPositioning case .RelativeToViewport)
					{
						DebugDraw(e.mChildren[n], 0, 0, depth - 1);
					}
					else
					{
						DebugDraw(e.mChildren[n], xOffset, yOffset, depth - 1);
					}
				}
			}
		}


		void DebugDrawMarginBox (UI.Element e, int xOffset, int yOffset)
		{
			if (this.mDebugDrawSettings.bDebugDrawMargin == false || e.mMargin.bIsEmpty == true)
				return;

			e.GetMarginBox(var x, var y, var width, var height);

			x += xOffset;
			y += yOffset;

			this.mRenderer.DrawRectOutline(
				x, y, width, height,
				e.mMargin.mLeft, e.mMargin.mTop, e.mMargin.mRight, e.mMargin.mBottom,
				this.mDebugDrawSettings.mMarginBoxColor
			);

			this.mRenderer.DrawRectOutline(x, y, width, height, this.mDebugDrawSettings.mMarginBoxBorderColor);
		}


		void DebugDrawBorderBox (UI.Element e, int xOffset, int yOffset)
		{
			if (this.mDebugDrawSettings.bDebugDrawBorder == false || e.mBorder.bIsEmpty == true)
				return;

			e.GetBorderBox(var x, var y, var width, var height);

			x += xOffset;
			y += yOffset;

			this.mRenderer.DrawRectOutline(
				x, y, width, height,
				e.mBorder.mLeft, e.mBorder.mTop, e.mBorder.mRight, e.mBorder.mBottom,
				this.mDebugDrawSettings.mBorderBoxColor
			);
		}


		void DebugDrawPaddingBox (UI.Element e, int xOffset, int yOffset)
		{
			if (this.mDebugDrawSettings.bDebugDrawPadding == false || e.mPadding.bIsEmpty == true)
				return;

			e.GetPaddingBox(var x, var y, var width, var height);

			x += xOffset;
			y += yOffset;

			this.mRenderer.DrawRectOutline(
				x, y, width, height,
				e.mPadding.mLeft, e.mPadding.mTop, e.mPadding.mRight, e.mPadding.mBottom,
				this.mDebugDrawSettings.mPaddingBoxColor
			);

			this.mRenderer.DrawRectOutline(
				x + e.mPadding.mLeft,
				y + e.mPadding.mTop,
				width - e.mPadding.mHorizontal,
				height - e.mPadding.mVertical,
				this.mDebugDrawSettings.mMarginBoxBorderColor
			);
		}


		void DebugDrawContentBox (UI.Element e, int xOffset, int yOffset)
		{
			if (this.mDebugDrawSettings.bDebugDrawContentBox == false || e.mBackgroundColor == .Transparent)
				return;

			e.GetContentBox(var x, var y, var width, var height);

			x += xOffset;
			y += yOffset;

			this.mRenderer.DrawRect(x, y, width, height, e.mBackgroundColor);
		}


		void DebugDrawBaseLine (UI.Element e, int xOffset, int yOffset)
		{
			if (this.mDebugDrawSettings.bDebugDrawBaseline == false)
				return;

			if (e.mTextContent?.bIsWhitespace == true)
				return;

			e.GetContentBox(var x, var y, var width, var height);

			x += xOffset;
			y += yOffset;

			var baseline = e.mBaseline;

			this.mRenderer.DrawLine(x, y + baseline, x + width, y + baseline, 1, this.mDebugDrawSettings.mBaselineColor);
		}


		void DebugDrawTextContent (UI.Element e, int xOffset, int yOffset)
		{
			if (e.mTextContent == null || e.mTextContent.bIsWhitespace == true)
				return;

			var texture = e.mTextContent.mFont.mTexture;
			var color = e.mTextContent.mColor;
			e.GetContentBox(var x, var y, var width, var height);
			//var colorIdx = 0;

			for (var n = 0; n < e.mTextContent.mSymbols.Count; n++)
			{
				var symbol = e.mTextContent.mSymbols[n];

				if (this.mDebugDrawSettings.bDebugDrawTextContentBounds)
				{
					this.mRenderer.DrawRect(
						int(symbol.mPosition.mX + xOffset + x),
						int(symbol.mPosition.mY + yOffset + y),
						int(symbol.mSize.mWidth),
						int(symbol.mSize.mHeight),
						Color.Red(),
						null
					);
				}

				this.mRenderer.DrawRect(
					symbol.mPosition + Vector2(xOffset + x, yOffset + y),
					symbol.mSize,
					symbol.mUV,
					color,
					texture
				);

				//colorIdx = Color.Red()//(colorIdx + 1) % sColorCircle.Count;
			}
		}


		void DebugDrawScrollBars (UI.Element e, int xOffset, int yOffset)
		{
			e.GetContentBox(var x, var y, var width, var height);

			if (e.bHorizontalScrollbarEnabled == true)
			{
				// Track
				this.mRenderer.DrawRect(
					x,
					y + height - this.mScrollBarSettings.mHorizontalScrollBarHeight,
					width,
					this.mScrollBarSettings.mHorizontalScrollBarHeight,
					this.mDebugDrawSettings.mScrollbarColor
				);

				// Left button
				this.mRenderer.DrawRect(
					x,
					y + height - this.mScrollBarSettings.mHorizontalScrollBarHeight,
					this.mScrollBarSettings.mHorizontalScrollBarHeight,
					this.mScrollBarSettings.mHorizontalScrollBarHeight,
					this.mDebugDrawSettings.mScrollbarButtonColor
				);

				if (e.bVerticalScrollBarEnabled == true)
				{
					// Right button
					this.mRenderer.DrawRect(
						x + width - this.mScrollBarSettings.mVerticalScrollBarWidth - this.mScrollBarSettings.mHorizontalScrollBarHeight,
						y + height - this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mDebugDrawSettings.mScrollbarButtonColor
					);
				}
				else
				{
					// Right button
					this.mRenderer.DrawRect(
						x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
						y + height - this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mDebugDrawSettings.mScrollbarButtonColor
					);
				}
			}

			if (e.bVerticalScrollBarEnabled == true)
			{
				// Track
				this.mRenderer.DrawRect(
					x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
					y,
					this.mScrollBarSettings.mVerticalScrollBarWidth,
					height,
					this.mDebugDrawSettings.mScrollbarColor
				);

				// Top button
				this.mRenderer.DrawRect(
					x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
					y,
					this.mScrollBarSettings.mVerticalScrollBarWidth,
					this.mScrollBarSettings.mVerticalScrollBarWidth,
					this.mDebugDrawSettings.mScrollbarButtonColor
				);

				if (e.bHorizontalScrollbarEnabled)
				{
					// Bottom button
					this.mRenderer.DrawRect(
						x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
						y + height - this.mScrollBarSettings.mVerticalScrollBarWidth - this.mScrollBarSettings.mHorizontalScrollBarHeight,
						this.mScrollBarSettings.mVerticalScrollBarWidth,
						this.mScrollBarSettings.mVerticalScrollBarWidth,
						this.mDebugDrawSettings.mScrollbarButtonColor
					);
				}
				else
				{
					// Bottom button
					this.mRenderer.DrawRect(
						x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
						y + height - this.mScrollBarSettings.mVerticalScrollBarWidth,
						this.mScrollBarSettings.mVerticalScrollBarWidth,
						this.mScrollBarSettings.mVerticalScrollBarWidth,
						this.mDebugDrawSettings.mScrollbarButtonColor
					);
				}
				/*{
					

					// Thumb
					//e.mVerticalScrollOffset = 0;
					//var foo = 56;

					var hundred = height - this.mScrollBarSettings.mVerticalScrollBarWidth * 2;
					var value = e.mVerticalScrollOffset;
					var thumbHeight = 30;
					var offsetY = ((value / e.mHeight.mCalculated) * hundred) + this.mScrollBarSettings.mVerticalScrollBarWidth;
					this.mRenderer.DrawRect(
						x + width - this.mScrollBarSettings.mVerticalScrollBarWidth,
						y + offsetY,
						this.mScrollBarSettings.mVerticalScrollBarWidth,
						thumbHeight,
						this.mDebugDrawSettings.mScrollbarThumbColor
					);

					
				}*/
			}
		}


		public void DebugDraw (UI.Element target, int depth)
		{

		}
	}
}