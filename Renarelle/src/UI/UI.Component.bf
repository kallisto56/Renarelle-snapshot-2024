namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class Component : UI.Element
	{
		public Event<OnMouseEnterDelegate> mOnMouseEnter ~ _.Dispose();
		public Event<OnMouseMoveDelegate> mOnMouseMove ~ _.Dispose();
		public Event<OnMouseLeaveDelegate> mOnMouseLeave ~ _.Dispose();
		public Event<OnMouseDownDelegate> mOnMouseDown ~ _.Dispose();
		public Event<OnMouseUpDelegate> mOnMouseUp ~ _.Dispose();
		public Event<OnMouseWheelDelegate> mOnMouseWheel ~ _.Dispose();

		public Event<OnKeyDownDelegate> mOnKeyDown ~ _.Dispose();
		public Event<OnKeyUpDelegate> mOnKeyUp ~ _.Dispose();

		public Event<OnFocusAcquiredDelegate> mOnFocusAcquired ~ _.Dispose();
		public Event<OnFocusLostDelegate> mOnFocusLost ~ _.Dispose();

		public UI.State mState = .IsNormal;


		virtual public void OnUpdate ()
		{

		}


		virtual public void OnRender (Window window, Renderer2D renderer)
		{

		}


		virtual public void OnMouseEnter (MouseEvent e)
		{
			if (this.mOnMouseEnter.HasListeners)
				this.mOnMouseEnter.Invoke(e);
		}


		virtual public void OnMouseMove (MouseEvent e)
		{
			if (this.mOnMouseMove.HasListeners)
				this.mOnMouseMove.Invoke(e);
		}


		virtual public void OnMouseLeave (MouseEvent e)
		{
			if (this.mOnMouseLeave.HasListeners)
				this.mOnMouseLeave.Invoke(e);
		}


		virtual public void OnMouseDown (MouseEvent e)
		{
			if (this.mOnMouseDown.HasListeners)
				this.mOnMouseDown.Invoke(e);
		}


		virtual public void OnMouseUp (MouseEvent e)
		{
			if (this.mOnMouseUp.HasListeners)
				this.mOnMouseUp.Invoke(e);
		}


		virtual public void OnMouseWheel (MouseEvent e)
		{
			if (this.mOnMouseWheel.HasListeners)
				this.mOnMouseWheel.Invoke(e);
		}



		virtual public void OnKeyDown (KeyEvent e)
		{
			if (this.mOnKeyDown.HasListeners)
				this.mOnKeyDown.Invoke(e);
		}


		virtual public void OnKeyUp (KeyEvent e)
		{
			if (this.mOnKeyUp.HasListeners)
				this.mOnKeyUp.Invoke(e);
		}



		virtual public void OnFocusAcquired (Event e)
		{
			if (this.mOnFocusAcquired.HasListeners)
				this.mOnFocusAcquired.Invoke(e);
		}


		virtual public void OnFocusLost (Event e)
		{
			if (this.mOnFocusLost.HasListeners)
				this.mOnFocusLost.Invoke(e);
		}
	}
}