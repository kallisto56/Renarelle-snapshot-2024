namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Math;


extension UI
{
	public class Button : UI.Component
	{
		String mLabel;
		public StringView Label
		{
			get { return this.mLabel; }
			set { this.SetText(value); }
		}

		public Color mTextColor = .Black(1);
		public Font mFont;

		public delegate void OnButtonPressedDelegate();
		public Event<OnButtonPressedDelegate> mOnPressed = .() ~ _.Dispose();

		public NinePatch? mNinePatch;


		public this ()
		{
			this.mLabel = new String();
			this.mContentAnchor = .Center;
			this.mPadding = 8;
		}


		public ~this ()
		{
			delete this.mLabel;
		}


		public void SetText (StringView text)
		{
			this.mLabel.Set(text);
			this.mChildren.ClearAndDeleteItems();
			this.Append(this.mLabel, this.mTextColor, this.mFont);
		}


		override public void OnUpdate ()
		{
		}


		override public void OnRender (Window window, Renderer2D r)
		{
			this.GetBorderBox(var x, var y, var width, var height);

			Color backgroundColor = .White(1);

			if (this.mState.HasFlag(.IsHovered))
				backgroundColor = .Red(1);

			if (this.mState.HasFlag(.IsPressed))
				backgroundColor = .SlateBlue(1);

			using (r.Push(backgroundColor))
			{
				r.DrawNinePatch(x, y, width, height, this.mNinePatch.Value);
			}
		}


		public override void OnKeyDown(KeyEvent e)
		{
			base.OnKeyDown(e);
			this.mState = .IsPressed;
		}


		public override void OnKeyUp(KeyEvent e)
		{
			base.OnKeyUp(e);
			this.mState = .IsNormal;

			if (this.mOnPressed.HasListeners)
				this.mOnPressed.Invoke();
		}


		public override void OnMouseDown (MouseEvent e)
		{
			base.OnMouseDown(e);
			this.mState = .IsPressed;
		}


		public override void OnMouseUp (MouseEvent e)
		{
			base.OnMouseUp(e);
			this.mState = .IsNormal;
			
			if (this.mOnPressed.HasListeners)
				this.mOnPressed.Invoke();
		}


		public override void OnMouseEnter (MouseEvent e)
		{
			base.OnMouseEnter(e);
			this.mState = .IsHovered;
		}


		public override void OnMouseLeave (MouseEvent e)
		{
			base.OnMouseLeave(e);
			this.mState = .IsNormal;
		}


		override public void OnMouseMove (MouseEvent e)
		{
			/*if (UI.IsPointInsideElement(e.mPosition, this))
			{
				if (Input.IsPressed(.Left) == true)
				{
					this.mState = .IsPressed;
				}
				else
				{
					this.mState = .IsHovered;
				}
			}
			else
			{
				this.mState = .IsNormal;
			}*/
		}
	}
}