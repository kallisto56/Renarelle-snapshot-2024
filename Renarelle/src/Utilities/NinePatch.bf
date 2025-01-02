namespace Renarelle;


using System;
using System.Collections;
using System.Diagnostics;
using System.Interop;
using System.Math;
using System.Threading;
using SDL3.Raw;


struct NinePatch
{
	public Texture mTexture;
	public Vector4 mBoundingRectangle;
	public float mCornerSize;


	public this (Texture texture, Vector4 bounds, float cornerSize)
	{
		this.mTexture = texture;
		this.mBoundingRectangle = bounds;
		this.mCornerSize = cornerSize;
	}


	public void Draw (Renderer2D g, float x, float y, float width, float height)
	{
		Vector2[16] uv;
		Vector2[16] vertices;

		// Calculating uv-coordinates
		{
			Vector2 uvScale = Vector2(this.mBoundingRectangle.mZ, this.mBoundingRectangle.mW);

			float u0 = 0F;
			float u1 = mCornerSize;
			float u2 = mCornerSize + (this.mTexture.mWidth - (this.mCornerSize * 2F));
			float u3 = this.mTexture.mWidth;

			float v0 = 0F;
			float v1 = mCornerSize;
			float v2 = mCornerSize + (this.mTexture.mHeight - (this.mCornerSize * 2F));
			float v3 = this.mTexture.mHeight;

			uv[00] = Vector2(u0, v0);
			uv[01] = Vector2(u1, v0);
			uv[02] = Vector2(u2, v0);
			uv[03] = Vector2(u3, v0);

			uv[04] = Vector2(u0, v1);
			uv[05] = Vector2(u1, v1);
			uv[06] = Vector2(u2, v1);
			uv[07] = Vector2(u3, v1);

			uv[08] = Vector2(u0, v2);
			uv[09] = Vector2(u1, v2);
			uv[10] = Vector2(u2, v2);
			uv[11] = Vector2(u3, v2);

			uv[12] = Vector2(u0, v3);
			uv[13] = Vector2(u1, v3);
			uv[14] = Vector2(u2, v3);
			uv[15] = Vector2(u3, v3);

			// Normalizing values
			Vector2 offset = Vector2(this.mBoundingRectangle.mX, this.mBoundingRectangle.mY);
			for (int n = 0; n < uv.Count; n++)
				uv[n] = (uv[n] + offset) / uvScale;
		}

		// Calculating pixel-coordinates
		{
			float u0 = 0F;
			float u1 = this.mCornerSize;
			float u2 = this.mCornerSize + (width - (this.mCornerSize * 2F));
			float u3 = width;

			float v0 = 0F;
			float v1 = this.mCornerSize;
			float v2 = this.mCornerSize + (height - (this.mCornerSize * 2F));
			float v3 = height;

			vertices[00] = Vector2(u0 + x, v0 + y);
			vertices[01] = Vector2(u1 + x, v0 + y);
			vertices[02] = Vector2(u2 + x, v0 + y);
			vertices[03] = Vector2(u3 + x, v0 + y);

			vertices[04] = Vector2(u0 + x, v1 + y);
			vertices[05] = Vector2(u1 + x, v1 + y);
			vertices[06] = Vector2(u2 + x, v1 + y);
			vertices[07] = Vector2(u3 + x, v1 + y);

			vertices[08] = Vector2(u0 + x, v2 + y);
			vertices[09] = Vector2(u1 + x, v2 + y);
			vertices[10] = Vector2(u2 + x, v2 + y);
			vertices[11] = Vector2(u3 + x, v2 + y);

			vertices[12] = Vector2(u0 + x, v3 + y);
			vertices[13] = Vector2(u1 + x, v3 + y);
			vertices[14] = Vector2(u2 + x, v3 + y);
			vertices[15] = Vector2(u3 + x, v3 + y);
		}

		var color = g.[Friend]mColors.Current;

		/*g.DrawQuad(
			.(vertices[00], uv[00], color),
			.(vertices[04], uv[04], color),
			.(vertices[05], uv[05], color),
			.(vertices[01], uv[01], color),
			this.mTexture
		);*/

		for (int xx = 0; xx < 3; xx++)
		{
		    for (int yy = 0; yy < 3; yy++)
		    {
		        int idx0 = xx * 4 + yy;
		        int idx1 = idx0 + 1;
		        int idx2 = idx0 + 4;
		        int idx3 = idx2 + 1;

		        var v0 = Renderer2D.Vertex2(vertices[idx0], uv[idx0], color);
		        var v1 = Renderer2D.Vertex2(vertices[idx1], uv[idx1], color);
		        var v2 = Renderer2D.Vertex2(vertices[idx3], uv[idx3], color);
		        var v3 = Renderer2D.Vertex2(vertices[idx2], uv[idx2], color);
		        g.DrawQuad(v0, v1, v2, v3, this.mTexture);
		    }
		}
	}
}