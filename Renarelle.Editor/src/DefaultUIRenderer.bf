namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


class DefaultUIRenderer : UI.IRenderer
{
	public Renderer2D mRenderer;


	public this (Renderer2D renderer)
	{
		this.mRenderer = renderer;
	}


	public IDisposable PushScissor (Scissor scissor)
	{
		if (this.mRenderer.GetCurrentScissor(var currentScissor) == true)
		{
			var clippedScissor = Scissor.Clip(currentScissor, scissor);
			return this.mRenderer.PushScissor(clippedScissor);
		}
		else
		{
			return this.mRenderer.PushScissor(scissor);
		}
	}


	public void PopScissor ()
	{
		this.mRenderer.PopScissor();
	}


	public void DrawRect (int x, int y, int width, int height, Color color, Texture texture = null)
	{
		this.mRenderer.DrawRect(x, y, width, height, color, texture);
	}


	public void DrawRect (Vector2 position, Vector2 size, Vector4 uv, System.Math.Color color, Texture texture = null)
	{
		using (this.mRenderer.PushColor(color))
		{
			var v0 = Renderer2D.Vertex2(
				Vector2(position.mX, position.mY),
				Vector2(uv.mX, uv.mY),
				color
			);

			var v1 = Renderer2D.Vertex2(
				Vector2(position.mX + size.mWidth, position.mY),
				Vector2(uv.mZ, uv.mY),
				color
			);

			var v2 = Renderer2D.Vertex2(
				Vector2(position.mX + size.mWidth, position.mY + size.mHeight),
				Vector2(uv.mZ, uv.mW),
				color
			);

			var v3 = Renderer2D.Vertex2(
				Vector2(position.mX, position.mY + size.mHeight),
				Vector2(uv.mX, uv.mW),
				color
			);

			this.mRenderer.DrawQuad(v0, v1, v2, v3, texture);
		}
	}


	public void DrawLine (int x0, int y0, int x1, int y1, int thickness, System.Math.Color color)
	{
		using (this.mRenderer.PushColor(color))
			this.mRenderer.DrawLine(x0, y0, x1, y1, thickness, null);
	}



	public void DrawRectOutline (int x, int y, int width, int height, System.Math.Color color)
	{
		using (this.mRenderer.PushColor(color))
		{
			this.mRenderer.DrawRect(x, y, width, 1, null);
			this.mRenderer.DrawRect(x, y+height-1, width, 1, null);

			this.mRenderer.DrawRect(x, y, 1, height, null);
			this.mRenderer.DrawRect(x+width-1, y, 1, height, null);
		}
	}


	public void DrawRectOutline (int x, int y, int width, int height, int left, int top, int right, int bottom, System.Math.Color color)
	{
		using (this.mRenderer.PushColor(color))
		{
			this.mRenderer.DrawRect(x, y, width, top, null);
			this.mRenderer.DrawRect(x, y+height-bottom, width, bottom, null);

			this.mRenderer.DrawRect(x, y+top, left, height-top-bottom, null);
			this.mRenderer.DrawRect(x+width-right, y+top, right, height-top-bottom, null);
		}
	}


	public void DrawRoundedRect (int x, int y, int width, int height, Color color, UI.Border border)
	{
		using (this.mRenderer.PushColor(color))
			this.mRenderer.DrawRect(x, y, width, height, null);
	}
}