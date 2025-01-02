namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class Tree
	{
		public UI.Layout mLayout;
		public UI.Element mRootElement;

		public UI.Component mFocusedElement;
		public UI.Component mHoveredElement;
		public UI.Component mPressedElement;

		public int mLeft;
		public int mTop;
		public Vector2 mMousePosition;


		public this (UI.Layout layout)
		{
			this.mLayout = layout;
		}


		public ~this ()
		{
			delete this.mRootElement;
		}


		public void OnUpdate ()
		{
			for (var n = 0; n < this.mRootElement.mChildren.Count; n++)
			{
				var child = this.mRootElement.mChildren[n];
				if (UI.Component component = child as UI.Component)
					component.OnUpdate();
			}

			this.mLayout.Compute(this.mRootElement);
			this.mRootElement.mLeft = this.mLeft;
			this.mRootElement.mTop = this.mTop;
		}


		public void OnRender (Window window, Renderer2D renderer)
		{
			this.mLayout.DebugDraw(this.mRootElement, this.mLeft, this.mTop);
		}


		public void OnMouseMove (MouseEvent e)
		{
			ApplyMouseEvent(e);
			var component = this.GetComponentUnderMouse(this.mRootElement);

			if (component != this.mHoveredElement)
				this.mHoveredElement?.OnMouseLeave(e);

			this.mHoveredElement = component;
			this.mHoveredElement?.OnMouseEnter(e);
		}


		public void OnMouseDown (MouseEvent e)
		{
			ApplyMouseEvent(e);
			var component = this.GetComponentUnderMouse(this.mRootElement);

			if (component != this.mFocusedElement)
				this.mFocusedElement?.OnFocusLost(e);

			this.mFocusedElement = component;
			this.mFocusedElement?.OnFocusAcquired(e);
			this.mFocusedElement?.OnMouseDown(e);
		}


		public void OnMouseUp (MouseEvent e)
		{
			ApplyMouseEvent(e);
			var component = this.GetComponentUnderMouse(this.mRootElement);
			if (component == this.mFocusedElement)
				component?.OnMouseUp(e);
		}


		public void OnMouseWheel (MouseEvent e)
		{
			ApplyMouseEvent(e);
		}


		void ApplyMouseEvent (MouseEvent e)
		{
			this.mMousePosition = e.mPosition;
		}



		public void OnKeyDown (KeyEvent e)
		{

		}


		public void OnKeyUp (KeyEvent e)
		{

		}


		UI.Component GetComponentUnderMouse (Element parent)
		{
			if (var component = parent as Component)
			{
				parent.GetBorderBox(var x, var y, var width, var height);
				if (this.InsideRectangle(this.mMousePosition, x, y, width, height))
					return component;
			}

			for (var n = 0; n < parent.mChildren.Count; n++)
			{
				var response = GetComponentUnderMouse(parent.mChildren[n]);
				if (response != null)
					return response;
			}

			return null;
		}


		bool InsideRectangle (Vector2 p, int x, int y, int width, int height)
		{
			if ((p.mX >= x && p.mX <= x + width) && (p.mY >= y && p.mY <= y + height))
				return true;

			return false;
		}
	}
}