namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


extension Renderer2D
{
	public void DrawTriangle (Vertex2 v0, Vertex2 v1, Vertex2 v2, Texture texture = null)
	{
		var texture;
		if (texture == null)
			texture = this.mDummyTexture;

		this.GetBatch(texture, this.mScissors.Current).mLength += 3;

		Matrix4x4 matrix = this.mMatrices.Current;
		var v0, v1, v2;

		if (this.mMatrices.Count > 0)
		{
			v0.mPosition = matrix * v0.mPosition;
			v1.mPosition = matrix * v1.mPosition;
			v2.mPosition = matrix * v2.mPosition;
		}

		uint32 index = uint32(this.mVertices.mCount);
		this.mVertices..Add(v0)..Add(v1)..Add(v2);
		this.mIndices..Add(index + 0)..Add(index + 1)..Add(index + 2);
	}


	public void DrawQuad (Vertex2 v0, Vertex2 v1, Vertex2 v2, Vertex2 v3, Texture texture = null)
	{
		this.DrawTriangle(v0, v1, v2, texture);
		this.DrawTriangle(v2, v0, v3, texture);
	}


	/*public void DrawRect (int x, int y, int width, int height, Color? color = null, Texture texture = null)
	{
		[Inline] this.DrawRect(x, y, width, height, color, texture);
	}*/

	public void DrawRect (Vector2 position, Vector2 size, Vector4 uv, System.Math.Color color, Texture texture = null)
	{
		using (this.Push(color))
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

			this.DrawQuad(v0, v1, v2, v3, texture);
		}
	}


	public void DrawRectOutline (int x, int y, int width, int height, int left, int top, int right, int bottom, System.Math.Color color)
	{
		using (this.Push(color))
		{
			this.DrawRect(x, y, width, top, null);
			this.DrawRect(x, y+height-bottom, width, bottom, null);

			this.DrawRect(x, y+top, left, height-top-bottom, null);
			this.DrawRect(x+width-right, y+top, right, height-top-bottom, null);
		}
	}


	public void DrawRect (float x, float y, float width, float height, Color? color = null, Texture texture = null)
	{
		var currentColor = color.HasValue ? color.Value : this.mColors.Current;

		Vertex2 v0 = Vertex2(Vector2(x, y), Vector2(0, 0), currentColor);
		Vertex2 v1 = Vertex2(Vector2(x+width, y), Vector2(1, 0), currentColor);
		Vertex2 v2 = Vertex2(Vector2(x+width, y+height), Vector2(1, 1), currentColor);
		Vertex2 v3 = Vertex2(Vector2(x, y+height), Vector2(0, 1), currentColor);

		this.DrawTriangle(v0, v1, v2, texture);
		this.DrawTriangle(v2, v0, v3, texture);
	}


	public void DrawRectOutline (int x, int y, int width, int height, System.Math.Color color)
	{
		using (this.Push(color))
		{
			this.DrawRect(x, y, width, 1, null);
			this.DrawRect(x, y+height-1, width, 1, null);

			this.DrawRect(x, y, 1, height, null);
			this.DrawRect(x+width-1, y, 1, height, null);
		}
	}


	public void DrawString (StringView textContent, float x, float y, Font font = null)
	{
		var color = this.mColors.Current;
		var font;

		if (font == null)
			font = this.mFonts.Current;

		var initialX = x;
		var x;
		var y;

		for (uint32 n = 0; n < textContent.Length; n++)
		{
			char32 lhs = textContent.GetChar32(n).c;
			char32? rhs = null;

			if (lhs == '\n')
			{
				y += font.mLineHeight;
				x = initialX;
				continue;
			}

			if (n + 1 < textContent.Length)
				rhs = textContent.GetChar32(n + 1).c;

			if (font.GetMetrics(lhs, rhs, var metrics) == false)
				continue;

			Vector4 srcRect = Vector4(metrics.mPixelCoords);

			var xx = int(x + metrics.mOffsetLeft);
			var yy = int(y - metrics.mOffsetTop);
			var ww = int(srcRect.mWidth);
			var hh = int(srcRect.mHeight);

			var p0 = Vector2(xx, yy);
			var p1 = Vector2(xx+ww, yy);
			var p2 = Vector2(xx+ww, yy+hh);
			var p3 = Vector2(xx, yy+hh);

			Vector4 uvs = Vector4(metrics.mTexCoords);

			var uv0 = Vector2(uvs.mLeft, uvs.mTop);
			var uv1 = Vector2(uvs.mRight, uvs.mTop);
			var uv2 = Vector2(uvs.mRight, uvs.mBottom);
			var uv3 = Vector2(uvs.mLeft, uvs.mBottom);

			this.DrawQuad(
				Vertex2(p0, uv0, color),
				Vertex2(p1, uv1, color),
				Vertex2(p2, uv2, color),
				Vertex2(p3, uv3, color),
				font.mTexture
			);

			x += metrics.mAdvanceWidth + metrics.mKerning.mX;
		}
	}


	public void DrawNinePatch (float x, float y, float width, float height, NinePatch ninePatch)
	{
		ninePatch.Draw(this, x, y, width, height);
	}


	public void DrawLines (Texture texture, float thickness, params Vector2[] coordinates)
	{
		var color = this.mColors.Current;

		for (var n = 1; n < coordinates.Count; n++)
		{
			Vector2 prev = coordinates[n-1];
			Vector2 current = coordinates[n];

			DrawLine(prev.mX, prev.mY, current.mX, current.mY, thickness, color, texture);
		}
	}


	public void DrawLine (float x0, float y0, float x1, float y1, float thickness, Color color, Texture texture = null)
	{
		float ang = Math.Atan2(y1 - y0, x1 - x0);

		// Add 1 pixel to account for transparent border
		float radius = (thickness / 2);// + 1;

		float xOfs = Math.Cos(ang + Math.PI_f / 2) * radius;
		float yOfs = Math.Sin(ang + Math.PI_f / 2) * radius;

		Vertex2 v0 = Vertex2(Vector2(x0-xOfs, y0-yOfs), Vector2(0, 0), color);
		Vertex2 v1 = Vertex2(Vector2(x1-xOfs, y1-yOfs), Vector2(1, 0), color);
		Vertex2 v2 = Vertex2(Vector2(x1+xOfs, y1+yOfs), Vector2(1, 1), color);
		Vertex2 v3 = Vertex2(Vector2(x0+xOfs, y0+yOfs), Vector2(0, 1), color);

		this.DrawTriangle(v0, v1, v2, texture);
		this.DrawTriangle(v2, v3, v0, texture);
	}


	[Inline]
	public IDisposable Push (Font font)
	{
		return this.mFonts.Push(font);
	}


	[Inline]
	public IDisposable Push (Color color)
	{
		return this.mColors.Push(color);
	}


	[Inline]
	public IDisposable Push (Matrix4x4 matrix)
	{
		return this.mMatrices.Push(matrix);
	}


	public IDisposable Push (Scissor scissor, bool bOverride = false)
	{
		if (bOverride == true)
			return this.mScissors.Push(scissor);

		if (this.GetCurrentScissor(var currentScissor) == true)
			return this.mScissors.Push(Scissor.Clip(currentScissor, scissor));

		return this.mScissors.Push(scissor);
	}


	public bool GetCurrentScissor (out Scissor currentScissor)
	{
		currentScissor = default;

		if (this.mScissors.Count > 0)
		{
			currentScissor = this.mScissors.Current;
			return true;
		}

		return false;
	}


	[Inline]
	public void PopScissor ()
	{
		this.mScissors.Pop();
	}
}
